{ ... }:
{
    flake.system-configuration = {
        enable = true;
        root_disk = "/dev/nvme0n1";
        users = {
            dax = {
                superuser = true;
                provision-ssh = true;
                groups = [ "users" ];
            };
        };
    };
    flake.openssh = {
        enable = true;
        sftp = true;
    };
    programs.dank-material-shell.greeter = {
        configHome = "/home/dax";
        compositor.customConfig = ''
            hotkey-overlay {
                skip-at-startup
            }

            environment {
                DMS_RUN_GREETER "1"
            }

            gestures {
                hot-corners {
                    off
                }
            }
            layout {
                background-color "#000000"
            }
            output "eDP-1" {
                mode "1920x1080@60"
                position x=0 y=0
                scale 1
                transform "normal"
            }
        '';
    };
}
