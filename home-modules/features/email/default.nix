{ pkgs, ... }:
{
    home.packages = with pkgs; [protonmail-bridge-gui birdtray];
    programs.thunderbird = {
        enable = true;
        profiles.default = {
            extensions = with pkgs.nur.repos.rycee.thunderbird-addons; [
              send-later
              tbkeys
            ]
            ;
        };
    };
}
