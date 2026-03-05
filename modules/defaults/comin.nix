{ lib, ... }:
{
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
}
