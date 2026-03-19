{ pkgs, ... }:
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
        ];
    };
}
