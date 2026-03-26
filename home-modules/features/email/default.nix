{ pkgs, lib, ... }:
let
    systray-x = pkgs.libsForQt5.callPackage ./systray-x.nix {};
in
{
    home.packages = with pkgs; [
        protonmail-bridge-gui
        systray-x
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
}
