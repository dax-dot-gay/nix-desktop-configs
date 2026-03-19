{ pkgs, ... }:
{
    home.packages = with pkgs; [
        protonmail-bridge-gui
        birdtray
    ];
    programs.thunderbird = {
        enable = true;
        profiles.default = {
            isDefault = true;
            extensions = with pkgs.nur.repos.rycee.thunderbird-addons; [
                send-later
                tbkeys
                filtaquilla
                filter-manager
                manually-sort-folders
            ];
        };
    };
    xdg.autostart.entries = [
        "${pkgs.protonmail-bridge-gui}/share/applications/protonmail-bridge-gui.desktop"
        "${pkgs.birdtray}/share/applications/com.ulduzsoft.Birdtray.desktop"
    ];
}
