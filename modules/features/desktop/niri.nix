{ pkgs, niri-wip, ... }:
{
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

    programs.niri = {
        enable = true;
        package = niri-wip.packages.${pkgs.stdenv.hostPlatform.system}.niri;
        withXDG = true;
        useNautilus = false;
    };
}
