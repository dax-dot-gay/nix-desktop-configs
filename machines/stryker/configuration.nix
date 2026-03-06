{ ... }:
{
    flake.system-configuration = {
        enable = true;
        root_disk = "nvme-Samsung_SSD_990_EVO_Plus_2TB_S7U6NU0Y756989N";
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
}
