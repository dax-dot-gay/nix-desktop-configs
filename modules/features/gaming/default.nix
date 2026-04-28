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
    environment.sessionVariables.XDG_DATA_DIRS = [ "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}" ];
}
