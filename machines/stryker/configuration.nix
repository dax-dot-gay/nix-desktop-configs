{ config, ... }:
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
        text =
          ''
            if [ ! -d /.persist ]; then
                install --mode=0700 --owner=root --group=root -d /.persist
            fi

            cp ${config.sops.secrets."data-key".path} /.persist/data-key
          '';
      };
    }
    ;
    environment.etc.crypttab = {
        mode = "0600";
        text = ''
            # <volume-name> <encrypted-device> [key-file] [options]
            cryptstorage UUID=59ca76bf-c608-47c3-b9ee-7f00b34aa98b /.persist/data-key
        '';
    };
    fileSystems."/mnt/data" = {
        depends = ["/"];
        device = "/dev/mapper/cryptstorage";
        fsType = "ext4";
        options = [
            "rw"
            "nofail"
            "users"
            "exec"
        ];
    };
    boot.kernelModules = [
        "video=DP-1:2560x1440@59.951"
        "video=DP-2:1920x1080@60,rotate=270"
        "video=HDMI-A-2:1920x1080@60"
    ];
}
