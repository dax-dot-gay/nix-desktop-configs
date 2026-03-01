{ ... }:
{
    catppuccin = {
        enable = true;
        flavor = "mocha";
        accent = "mauve";
        gtk = {
            icon.enable = true;
        };
        vscode.enable = false;
    };
    stylix = {
        enable = true;
        autoEnable = false;
        targets.gtk = {
            enable = true;
            flatpakSupport.enable = true;
            fonts.enable = true;
        };
    };
}
