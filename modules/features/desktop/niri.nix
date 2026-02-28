{ pkgs, ... }:
{
    programs.niri = {
        enable = true;
        package = pkgs.niri;
    };
    niri-flake.cache.enable = false;
    environment.variables = {
        NIXOS_OZONE_WL = "1";
        XDG_CURRENT_DESKTOP = "GNOME";
        QT_QPA_PLATFORMTHEME = "gtk3";
    };

    environment.systemPackages = with pkgs; [
        wl-clipboard
        wayland-utils
        libsecret
        cage
        gamescope
        xwayland-satellite
    ];
}
