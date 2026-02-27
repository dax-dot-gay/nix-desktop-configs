{...}:
{
    flake.system-configuration = {
        enable = true;
        root_disk = "/dev/vda";
        users = {
            dax = {
                superuser = true;
                allowSystemConfiguration = true;
            };
        };
        stateVersion = "25.11";
    };
    flake.openssh = {
        enable = true;
        sftp = true;
    };
    programs.zsh.enable = true;
}
