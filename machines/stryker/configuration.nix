{ config, lib, ... }:
{
    flake.system-configuration = {
        enable = true;
        root_disk = "/dev/disk/by-id/nvme-Samsung_SSD_990_EVO_Plus_2TB_S7U6NU0Y756989N";
        users = {
            dax = {
                superuser = true;
                provision-ssh = true;
            };
        };
        stateVersion = "25.11";
    };
    flake.openssh = {
        enable = true;
        sftp = true;
    };
    flake.secrets.local."data-key" = {
        neededForUsers = true;
    };
    system.activationScripts = {
        persist-secret-key = {
            # Run after /dev has been mounted
            deps = [ "setupSecrets" ];
            text = ''
                if [ ! -d /.persist ]; then
                    install --mode=0700 --owner=root --group=root -d /.persist
                fi

                cp ${config.sops.secrets."data-key".path} /.persist/data-key
            '';
        };
    };
    environment.etc.crypttab = {
        mode = "0600";
        text = ''
            # <volume-name> <encrypted-device> [key-file] [options]
            cryptstorage UUID=59ca76bf-c608-47c3-b9ee-7f00b34aa98b /.persist/data-key
        '';
    };
    fileSystems."/mnt/data" = {
        depends = [ "/" ];
        device = "/dev/mapper/cryptstorage";
        fsType = "ext4";
        options = [
            "rw"
            "nofail"
            "users"
            "exec"
        ];
    };
    boot.kernelParams = [
        "video=DP-1:2560x1440@240"
        "video=DP-2:2560x1440@240"
        "video=HDMI-A-2:1920x1080@60,rotate=270"
    ];
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

            output "DP-1" {
                mode "2560x1440@240"
                position x=1080 y=480
                scale 1
                transform "normal"
            }
            output "DP-2" {
                mode "2560x1440@240"
                position x=3640 y=480
                scale 1
                transform "normal"
            }
            output "HDMI-A-2" {
                mode "1920x1080@60"
                position x=0 y=0
                scale 1
                transform "270"
            }
        '';
    };
    networking.interfaces = {
        wlp10s0.useDHCP = lib.mkForce false;
        enp7s0.useDHCP = lib.mkForce false;
        enp20s0f3u1u4u3.useDHCP = lib.mkForce false;
    };
    systemd.services."network-addresses-enp7s0".enable = lib.mkForce false;
    systemd.services."network-addresses-wlp9s0".enable = lib.mkForce false;
    systemd.services."network-addresses-enp20s0f3u1u4u3".enable = lib.mkForce false;
    systemd.services."network-addresses-wlp10s0".enable = lib.mkForce false;
}
