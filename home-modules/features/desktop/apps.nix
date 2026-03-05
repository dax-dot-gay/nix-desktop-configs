{ pkgs, ... }:
{
    home.packages = with pkgs; [
        feishin
        element-desktop
        equibop
        zoom-us
        delfin
    ];
    programs.keepassxc = {
        enable = true;
        autostart = true;
    };
    services.syncthing = {
        enable = true;
        tray.enable = true;
    };
}
