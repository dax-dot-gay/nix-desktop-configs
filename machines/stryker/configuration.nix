{ ... }:
{
    flake.system-configuration = {
        enable = true;
        root_disk = "/dev/nvme0n1";
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
