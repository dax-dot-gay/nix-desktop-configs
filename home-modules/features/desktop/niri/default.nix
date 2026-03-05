{awww, pkgs, ...}: {
    imports = [
        ./config.nix
    ];
    home.file.".config/assets/wallpaper.gif".source = ./wallpaper.gif;
    services.swww = {
        enable = true;
        package = awww.packages.${pkgs.stdenv.hostPlatform.system}.awww;
    };
}