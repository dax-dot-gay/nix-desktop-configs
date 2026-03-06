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
        ./browser
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
    xdg.configFile."gtk-3.0/bookmarks".text = ''
        file:///mnt/data data
        file:///mnt/data/Programming Programming
    '';
    home.file = let mkSymlink = name: mkOutOfStoreSymlink "/mnt/data/user_folders/${name}"; in {
        ".icons/default".source = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";
        Desktop.source = mkSymlink "Desktop";
        Documents.source = mkSymlink "Documents";
        Downloads.source = mkSymlink "Downloads";
        Music.source = mkSymlink "Music";
        Pictures.source = mkSymlink "Pictures";
        Public.source = mkSymlink "Public";
        Templates.source = mkSymlink "Templates";
        Videos.source = mkSymlink "Videos";
    };
}
