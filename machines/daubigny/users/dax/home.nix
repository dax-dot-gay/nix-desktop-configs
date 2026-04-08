{ pkgs, config, ... }:
{
    imports = [ ./niri.nix ];
    xdg.configFile."gtk-3.0/bookmarks".text = ''
        file:///home/dax/Downloads Downloads
        file:///home/dax/Pictures  Pictures
        file:///home/dax/Documents Documents
    '';
    home.file = {
        ".icons/default".source = "${pkgs.adwaita-icon-theme}/share/icons/Adwaita";
    };
    homeflake.browser = {
        floorp.enable = true;
        librewolf.enable = true;
    };
}
