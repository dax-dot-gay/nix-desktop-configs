{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        feishin
        cinny-desktop
        equibop
        zoom-us
        delfin
    ];
}
