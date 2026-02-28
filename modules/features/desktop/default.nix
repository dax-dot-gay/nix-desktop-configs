{
    niri-flake,
    dms,
    catppuccin,
    ...
}:
{
    imports = [
        niri-flake.nixosModules.niri
        dms.nixosModules.dank-material-shell
        catppuccin.nixosModules.catppuccin
        ./style
    ];
}
