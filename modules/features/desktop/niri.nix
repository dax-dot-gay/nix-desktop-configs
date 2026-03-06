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
    xdg.portal.config.niri = {
        "default" = ["gtk" "gnome"];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.Access" = ["gtk"];
        "org.freedesktop.impl.portal.Notification" = ["gtk"];
        "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
    };
    xdg.portal.extraPortals = with pkgs; [
        gnome-keyring
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
    ];
}
