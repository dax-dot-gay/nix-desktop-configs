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
        mount-data = {
            # Run after /dev has been mounted
            deps = [ "setupSecrets" ];
            text = ''
                if [ ! -d /mnt/data ]; then
                    install --mode=0777 --owner=dax --group=dax -d /mnt/data
                fi

                cryptsetup open /dev/disk/by-id/nvme-Samsung_SSD_990_EVO_Plus_4TB_S7U8NJ0Y910545E cryptdata --key-file ${config.sops.secrets."data-key".path}
                mount /dev/mapper/cryptdata /mnt/data
            '';
        };
    };
}
