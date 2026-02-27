{ lib, hostname, ... }:
{
    imports = [
        ./boot.nix
        ./system.nix
        ./secrets.nix
        ./network.nix
        ./openssh.nix
        ./shell.nix
        ./style.nix
        ../../machines/${hostname}/auto.nix
    ];

    system.stateVersion = "25.11";
    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];
    hardware.facter.reportPath = lib.mkIf (builtins.pathExists ../../machines/${hostname}/facter.json) ../../machines/${hostname}/facter.json;
}
