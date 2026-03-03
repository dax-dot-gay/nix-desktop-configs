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
    ];

    programs.niri = {
        enable = true;
        variant = "stable";
        withXDG = true;
        useNautilus = false;
    };
}
