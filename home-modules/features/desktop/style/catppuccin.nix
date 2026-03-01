{ pkgs, ... }:
{
    stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        autoEnable = true;
        targets.gtk = {
            enable = true;
            flatpakSupport.enable = true;
            fonts.enable = true;
        };
    };
}
