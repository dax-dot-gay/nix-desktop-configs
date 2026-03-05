{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        ccid
        pcsc-tools
        pynitrokey
        nitrokey-app2
        gnupg
        libfido2
    ];
}
