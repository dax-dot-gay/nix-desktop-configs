{
    dms,
    catppuccin,
    dms-plugin-registry,
    niri-nix,
    pkgs,
    ...
}:
{
    imports = [
        catppuccin.homeModules.catppuccin
        dms.homeModules.dank-material-shell
        dms-plugin-registry.modules.default
        niri-nix.homeModules.default
        ./style
        ./dms.nix
        ./development
    ];
    home.packages = with pkgs; [
        nemo
        nemo-fileroller
        nemo-preview
    ];
    programs.vicinae = {
        enable = true;
        settings = {
            faviconService = "twenty";
            theme = {
                dark = {
                    name = "catppuccin-mocha";
                };
            };
        };
    };
}
