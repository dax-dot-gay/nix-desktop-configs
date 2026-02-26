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
    ];

    scripts = {
        make-password.exec = ''
            cd $(git rev-parse --show-toplevel)
            read -s -p "Enter password for $2 on $1:" password
            echo

            hashed=$(mkpasswd $password)

            sops set secrets/machines/$1/secrets.yaml "[\"users\"][\"$2\"][\"password\"]" "\"$hashed\""
        '';
        new-machine.exec = ''
            cd $(git rev-parse --show-toplevel)
            mkdir -p machines/$1
            cat <<EOF > machines/$1/configuration.nix
            {...}:
            {

            }
            EOF

            mkdir -p machines/$1/.machine-secrets/etc/ssh/ machines/$1/.machine-secrets/ssh
            ssh-keygen -A -f machines/$1/.machine-secrets
            mv machines/$1/.machine-secrets/etc/ssh/* machines/$1/.machine-secrets/ssh
            sed -i -e 's/$(id -un)@$(hostname)/root@$1/g' machines/$1/.machine-secrets/ssh/*.pub
            rm -rf machines/$1/.machine-secrets/etc
            mkdir -p secrets/machines/$1

            AGE_KEY=$(ssh-to-age -i machines/$1/.machine-secrets/ssh/ssh_host_ed25519_key.pub)
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
