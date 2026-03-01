{ pkgs, ... }:
{
    catppuccin = {
        enable = true;
        flavor = "mocha";
        accent = "mauve";
        plymouth.enable = false;
        tty.enable = false;
    };
    stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        autoEnable = true;
    };
    boot.plymouth.enable = true;
    gtk.iconTheme = pkgs.catppuccin-papirus-folders.override { accent = "mauve"; flavor = "mocha"; };
}
