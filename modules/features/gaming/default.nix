{ pkgs, eden-emu, ... }:
{
    imports = [
        ./steam.nix
        eden-emu.nixosModules.default
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
    ];
    programs.eden.enable = true;
}
