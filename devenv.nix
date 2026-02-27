{
    pkgs,
    ...
}:

{
    packages = with pkgs; [
        git
        nixos-anywhere
        openssh
        ssh-to-age
        sops
        nixd
        nixfmt-rfc-style
        hostname
        yq-go
        mkpasswd
        openssl
    ];

    scripts = {

        make-password.exec = ''
            cd $(git rev-parse --show-toplevel)
            read -s -p "Enter password for $2 on $1:" password
            echo

            hashed=$(mkpasswd $password)

            sops set secrets/machines/$1/secrets.yaml "[\"users\"][\"$2\"][\"password\"]" "\"$hashed\""
        '';
        deploy.exec = ''
            if [ $# -ne 2 ]; then
                echo "Usage: deploy <hostname> <target_ip>"
                exit 1
            fi

            HOSTNAME=$1
            TARGET_IP=$2
            BRANCH=$(git rev-parse --abbrev-ref HEAD)
            REMOTE=$(git remote get-url origin)

            git clone --branch $BRANCH $REMOTE "machines/$HOSTNAME/.machine-secrets/etc/nixos"
            chmod -R 770 "machines/$HOSTNAME/.machine-secrets/etc/nixos"

            cd $(git rev-parse --show-toplevel)
            nixos-anywhere \
                --extra-files "machines/$HOSTNAME/.machine-secrets" \
                --chown /etc/nixos 0:101 \
                --flake ".#$HOSTNAME" --target-host nixos@$TARGET_IP \
                --generate-hardware-config nixos-generate-config machines/$HOSTNAME/hardware-configuration.nix

            rm -rf "machines/$HOSTNAME/.machine-secrets/etc/nixos"
            ssh-keygen -R $TARGET_IP
        '';
        new-machine.exec = ''
            cd $(git rev-parse --show-toplevel)
            mkdir -p machines/$1
            cat <<EOF > machines/$1/configuration.nix
            {...}:
            {

            }
            EOF

            cat <<EOF > machines/$1/auto.nix
            {...}:
            {
                networking.hostId = "$(openssl rand -hex 4)";
            }
            EOF

            mkdir -p machines/$1/.machine-secrets
            install -d -m755 "machines/$1/.machine-secrets/etc/ssh"
            ssh-keygen -A -f machines/$1/.machine-secrets
            sed -i -e 's/$(id -un)@$(hostname)/root@$1/g' machines/$1/.machine-secrets/etc/ssh/*.pub
            mkdir -p secrets/machines/$1
            chmod 600 machines/$1/.machine-secrets/etc/ssh/*

            AGE_KEY=$(ssh-to-age -i machines/$1/.machine-secrets/etc/ssh/ssh_host_ed25519_key.pub)
            CODE=$(cat << EOF
            .keys += "$AGE_KEY" | 
            .keys[-1] anchor = "sys-$1" | 
            .creation_rules[0].key_groups[0].age += "placeholder" | 
            .creation_rules[0].key_groups[0].age[-1] alias = "sys-$1" |
            .creation_rules += {
                "path_regex": "secrets/machines/$1/[^/]+\.(yaml|json|env|ini)$",
                "key_groups": [
                    {
                        "age": [
                            "placeholder",
                            "placeholder"
                        ]
                    }
                ]
            } |
            .creation_rules[-1].key_groups[0].age[0] alias = "dax" |
            .creation_rules[-1].key_groups[0].age[1] alias = "sys-$1"
            EOF
            )

            yq -i eval "$CODE" .sops.yaml
            echo "---" > secrets/machines/$1/secrets.yaml
            sops encrypt -i secrets/machines/$1/secrets.yaml
            sops updatekeys -y secrets/secrets.yaml

            for user in $(seq 2 $#);
            do
                mkdir -p machines/$1/users/''${!user}
                cd machines/$1/users/''${!user}

                cat <<EOF > home.nix
            {...}:
            {
            }
            EOF
                cd $(git rev-parse --show-toplevel)
            done
        '';
    };
}
