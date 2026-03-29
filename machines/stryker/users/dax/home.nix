{ pkgs, config, ... }:
with config.lib.file;
{
    imports = [
        ./niri.nix
    ];

    xdg.configFile."gtk-3.0/bookmarks".text = ''
        file:///mnt/data Data
        file:///home/dax/Downloads Downloads
        file:///home/dax/Documents Documents
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
    homeflake.browser = {
        librewolf.enable = true;
        floorp.enable = true;
        chromium.enable = true;
    };
}
