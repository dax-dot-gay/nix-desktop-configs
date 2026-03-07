{ lib, pkgs, ... }:
{
    environment.systemPackages = [
        pkgs.libnotify pkgs.jq pkgs.jq-zsh-plugin
    ];
    services.comin = {
        enable = true;
        deployConfirmer = {
            mode = lib.mkDefault "manual";
        };
        remotes = [
            {
                name = "origin";
                url = "https://github.com/dax-dot-gay/nix-desktop-configs.git";
                branches.main.name = "main";
            }
        ];
    };
    systemd.services."check-and-notify-update" = {
        wantedBy = ["default.target"];
        wants = ["multi-user.target"];
        script = ''
            while read -r event
            do
                if [[ $event == buildFinishedType* ]]; then
                    if [ ! "$(comin status --json | jq .deploy_confirmer.submitted)" == '""' ]; then
                        for id in $(loginctl list-sessions -j | jq -r '.[] | .session') ; do
                            if [[ $(loginctl show-session "$id" --property=Type) =~ (wayland|x11) ]] ; then
                                USER=$(loginctl show-session "$id" --property=Name --value)
                                if [ ! -e "/home/$USER/.local/share/comin-deployment" ] || [ ! "$(cat "/home/$USER/.local/share/comin-deployment")" == "$(echo "$(comin status --json)" | jq .deploy_confirmer.submitted)" ]; then
                                    comin status --json | jq .deploy_confirmer.submitted > "/home/$USER/.local/share/comin-deployment"
                                    COMMIT=$(comin status --json | jq ".builder.generation.selected_commit_msg | trimstr(\"\n\")")
                                    RESPONSE=$(sudo -u "$USER" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/"$(id -u "$USER")"/bus notify-send --urgency=critical --app-name="Comin" --action=update=Update "Update Available!" "Commit: $COMMIT")
                                    if [ "$RESPONSE" == "update" ]; then
                                        comin confirmation accept
                                    fi
                                fi
                            fi
                        done
                    fi
                fi
            done < <(comin events)
        '';
        serviceConfig = {
            User = "root";
        };
        path = ["/run/current-system/sw"];
    };
}
