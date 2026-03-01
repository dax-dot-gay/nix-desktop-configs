{ pkgs, ... }:
{
    catppuccin = {
        enable = true;
        flavor = "mocha";
        accent = "mauve";
        plymouth.enable = false;
        tty.enable = false;
        gtk = {
            icon.enable = true;
        };
    };
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
