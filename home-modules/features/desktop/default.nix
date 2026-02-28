{ inputs, ... }:
{
    imports = [
        inputs.catppuccin.homeModules.catppuccin
        inputs.dms.homeModules.dank-material-shell
        ./style
    ];
}
