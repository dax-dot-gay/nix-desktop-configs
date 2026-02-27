{ lib, hostname, ... }:
{
    imports = [
        ./boot.nix
        ./system.nix
        ./secrets.nix
        ./network.nix
        ./openssh.nix
        ../../machines/${hostname}/auto.nix
    ]
    ++ (lib.optional (builtins.pathExists ../../machines/${hostname}/hardware-configuration.nix) ../../machines/${hostname}/hardware-configuration.nix);

    system.stateVersion = "25.11";
}
