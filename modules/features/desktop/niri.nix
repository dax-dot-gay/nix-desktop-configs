{ pkgs, ... }:
{
    environment.variables = {
        NIXOS_OZONE_WL = "1";
        XDG_CURRENT_DESKTOP = "GNOME";
    };

    environment.systemPackages = with pkgs; [
        wl-clipboard
        wayland-utils
        libsecret
        cage
        gamescope
        xwayland-satellite
        dconf-editor
    ];
    programs.niri = {
        enable = true;
        variant = "stable";
        withXDG = true;
        useNautilus = false;
    };
    xdg.portal.enable = true;
    xdg.portal.config.niri = {
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
        "default" = "gnome";
    };
    xdg.portal.extraPortals = with pkgs; [
        gnome-keyring
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
    ];
}
