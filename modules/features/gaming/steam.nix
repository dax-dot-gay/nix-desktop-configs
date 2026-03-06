{ pkgs, ... }:
{
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        extraCompatPackages = with pkgs; [
            proton-ge-bin
        ];
        package = pkgs.steam.override {
            extraPkgs =
                p: with p; [
                    libXcursor
                    libXi
                    libXinerama
                    libXScrnSaver
                    libpng
                    libpulseaudio
                    libvorbis
                    stdenv.cc.cc.lib # Provides libstdc++.so.6
                    libkrb5
                    keyutils
                ];
        };
    };
    programs.gamescope = {
        enable = true;
        capSysNice = true;
    };
    environment.systemPackages = with pkgs; [
        steam-run
        gamescope-wsi
        protontricks
        winetricks
        steamtinkerlaunch
    ];
}
