{awww, pkgs, ...}: {
    imports = [
        ./config.nix
    ];
    home.file.".config/assets/wallpaper.gif".source = ./wallpaper.gif;
    home.packages = [
        awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    ];
}