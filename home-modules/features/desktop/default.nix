{
    dms,
    catppuccin,
    dms-plugin-registry,
    nirix,
    nix-monitor,
    pkgs,
    ...
}:
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
        ./browser.nix
        ./niri
    ];
    home.packages = with pkgs; [
        nemo
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
    home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";
    gtk.cursorTheme.name = "Vanilla-DMZ";
}
