{ pkgs, ... }:
{
    home.packages = with pkgs; [
        feishin
        cinny-desktop
        equibop
        zoom-us
        delfin
    ];
}
