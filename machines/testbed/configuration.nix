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
    };
}
