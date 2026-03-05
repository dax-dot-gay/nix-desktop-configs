{ pkgs, ... }:
{
    home.packages = with pkgs; [
        feishin
        fluffychat
        equibop
        zoom-us
        delfin
    ];
}
