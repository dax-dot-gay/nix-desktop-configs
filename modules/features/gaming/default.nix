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
        zenity
        p7zip
        websocat
        protontricks
        winetricks
    ];
}
