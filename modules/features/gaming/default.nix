{ pkgs, ... }:
{
    imports = [
        ./steam.nix
    ];
    environment.systemPackages = with pkgs; [
        (prismlauncher.override {
            additionalPrograms = [ffmpeg];
        })
        modrinth-app
        ckan
        satisfactorymodmanager
        zenity
        p7zip
        websocat
        wine
        wine64
        eden
    ];
}
