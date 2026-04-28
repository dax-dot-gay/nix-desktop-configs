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
        targets.librewolf.colors.enable = false;
        targets.librewolf.colorTheme.enable = true;
        targets.floorp.profileNames = ["default"];
        targets.floorp.colors.enable = false;
        targets.floorp.colorTheme.enable = true;
        targets.dank-material-shell.enable = false;
    };
    gtk.iconTheme.package = pkgs.catppuccin-papirus-folders.override { accent = "mauve"; flavor = "mocha"; };
    gtk.iconTheme.name = "Papirus-Dark";
}
