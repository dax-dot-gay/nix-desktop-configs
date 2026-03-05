{ lib, pkgs, comin, ... }:
{
    environment.systemPackages = [
        pkgs.libnotify pkgs.jq pkgs.jq-zsh-plugin pkgs.polkit
    ];
    services.comin = {
        enable = true;
        deployConfirmer = {
            mode = lib.mkDefault "manual";
        };
        desktop = {
            enable = true;
            title = "Comin - Update Service";
        };
        remotes = [
            {
                name = "origin";
                url = "https://github.com/dax-dot-gay/nix-desktop-configs.git";
                branches.main.name = "main";
            }
        ];
    };
    systemd.timers."check-and-notify-update" = {
        wantedBy = ["timers.target"];
        timerConfig = {
            OnBootSec = "60sec";
            OnUnitActiveSec = "60sec";
            Unit = "check-and-notify-update.service";
        };
    };
    systemd.services."check-and-notify-update" = {
        wantedBy = ["default.target"];
        wants = ["multi-user.target"];
        script = ''
            if [ ! $(echo "$(comin status --json)" | jq .deploy_confirmer.submitted) == '""' ]; then
                for id in $(loginctl list-sessions -j | jq -r '.[] | .session') ; do
                    if [[ $(loginctl show-session $id --property=Type) =~ (wayland|x11) ]] ; then
                        USER=$(loginctl show-session $id --property=Name --value)
                        if [ ! -e /home/$USER/.local/share/comin-deployment ] || [ ! $(cat /home/$USER/.local/share/comin-deployment) == $(echo "$(comin status --json)" | jq .deploy_confirmer.submitted) ]; then
                            echo $(echo "$(comin status --json)" | jq .deploy_confirmer.submitted) > /home/$USER/.local/share/comin-deployment
                            RESPONSE=$(sudo -u $USER DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $USER)/bus notify-send --urgency=critical --app-name="Comin" --action=update=Update "Update Available!" "A deployment is available for deployment. To validate the build, run <sudo journalctl -xeu comin>")
                            if [ $RESPONSE == "update" ]; then
                                pkexec comin confirmation accept
                            fi
                        fi
                    fi
                done
            fi
        '';
        serviceConfig = {
            Type = "oneshot";
            User = "root";
            RemainAfterExit = true;
        };
        path = ["/run/current-system/sw"];
    };
}
