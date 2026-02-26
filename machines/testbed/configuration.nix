{...}:
{
    flake.system-configuration = {
        enable = true;
        root_disk = "/dev/vda";
        users = {
            dax = {
                superuser = true;
            };
        };
        stateVersion = "25.11";
    };
    flake.openssh = {
        enable = true;
        sftp = true;
    };
}
