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
        targets.vscode.enable = false;
        targets.librewolf.profileNames = ["default"];
    };
    gtk.iconTheme.package = pkgs.catppuccin-papirus-folders.override { accent = "mauve"; flavor = "mocha"; };
    gtk.iconTheme.name = "Catppuccin Mocha Mauve";
}
