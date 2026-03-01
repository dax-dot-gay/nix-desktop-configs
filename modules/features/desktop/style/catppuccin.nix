{ pkgs, ... }:
{
    stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        autoEnable = false;
        targets = {
            gtk.enable = true;
            plymouth.enable = true;
        };
    };
    boot.plymouth.enable = true;
}
