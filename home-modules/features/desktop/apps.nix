{ pkgs, nix-obsidian-plugins, currentSystem, ... }:
let
    plugins = nix-obsidian-plugins.plugins.${currentSystem};
    themes = nix-obsidian-plugins.themes.${currentSystem};
in
{
    home.packages = with pkgs; [
        feishin
        cinny-desktop
        equibop
        delfin
        libreoffice-fresh
    ];
    services.syncthing = {
        enable = true;
        tray.enable = true;
    };
    xdg.autostart = {
        enable = true;
        entries = [
            "${pkgs.keepassxc}/share/applications/org.keepassxc.KeePassXC.desktop"
            "${pkgs.equibop}/share/applications/equibop.desktop"
            "${pkgs.cinny-desktop}/share/applications/Cinny.desktop"
        ];
    };
    programs.obsidian = {
        enable = true;
    };
}
