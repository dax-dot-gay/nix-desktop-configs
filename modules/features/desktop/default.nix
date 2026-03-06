{
    pkgs,
    dms,
    catppuccin,
    nix-monitor,
    nirix,
    stylix,
    ...
}:
{
    imports = [
        dms.nixosModules.dank-material-shell
        dms.nixosModules.greeter
        catppuccin.nixosModules.catppuccin
        nix-monitor.nixosModules.default
        nirix.nixosModules.default
        stylix.nixosModules.stylix
        ./style
        ./dms.nix
        ./niri.nix
    ];
    environment.systemPackages = [
        pkgs.keepassxc
    ];
    services.gvfs.enable = true;
    services.udisks2 = {
        enable = true;
    };
}
