{ pkgs, ... }:
{
    home.packages = with pkgs; [
        protonmail-bridge-gui
        birdtray
    ];
    programs.thunderbird = {
        enable = true;
        profiles.default = {
            name = "default";
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
}
