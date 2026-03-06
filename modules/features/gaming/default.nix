{ pkgs, ... }:
{
    imports = [
        ./steam.nix
    ];
    environment.systemPackages = with pkgs; [
        (prismlauncher.override {
            additionalPrograms = [ffmpeg];
        })
        ckan
        satisfactorymodmanager
    ];
}
