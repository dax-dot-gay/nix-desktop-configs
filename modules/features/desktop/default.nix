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
        ./printers.nix
    ];
    environment.systemPackages = [
        pkgs.keepassxc
    ];
    services.gvfs.enable = true;
    services.udisks2 = {
        enable = true;
    };
    programs.localsend = {
        enable = true;
        openFirewall = true;
    };
    programs.appimage = {
        enable = true;
        binfmt = true;
        package = pkgs.appimage-run.override {
            extraPkgs = pkgs: [
                pkgs.icu
            ];
        };
    };
}
