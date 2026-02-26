{ lib, hostname, ... }:
{
    imports = [
        ./boot.nix
        ./system.nix
        ./secrets.nix
    ]
    ++ (lib.optional (builtins.pathExists ./machines/${hostname}/facter.json) [
        { hardware.facter.reportPath = ./machines/${hostname}/facter.json; }
    ]);

    system.stateVersion = "25.11";
}
