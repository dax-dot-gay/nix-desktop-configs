{ pkgs, ... }:
{
    catppuccin = {
        enable = true;
        flavor = "mocha";
        accent = "mauve";
        gtk = {
            icon.enable = false;
        };
        vscode.profiles.default.enable = false;
    };
    stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        autoEnable = false;
        targets.gtk = {
            enable = true;
            flatpakSupport.enable = true;
            fonts.enable = true;
        };
        targets.vscode.enable = false;
    };
}
