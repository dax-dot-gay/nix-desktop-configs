{
    dms,
    catppuccin,
    dms-plugin-registry,
    nirix,
    nix-monitor,
    pkgs,
    config,
    ...
}:
with config.lib.file;
{
    imports = [
        catppuccin.homeModules.catppuccin
        dms.homeModules.dank-material-shell
        dms-plugin-registry.modules.default
        nirix.homeModules.default
        nix-monitor.homeManagerModules.default
        ./style
        ./dms.nix
        ./development
        ./niri
        ./apps.nix
    ];
    home.packages = with pkgs; [
        nemo-with-extensions
        nemo-fileroller
        nemo-preview
    ];
    programs.vicinae = {
        enable = true;
        settings = {
            faviconService = "twenty";
        };
        systemd.enable = true;
        systemd.autoStart = true;
    };
    gtk.cursorTheme = {
        name = "Adwaita";
    };
    xdg.autostart.enable = true;
    dconf = {
        enable = true;
        settings = {
            "org/nemo/preferences" = {
                show-hidden-files = true;
            };
        };
    };
}
