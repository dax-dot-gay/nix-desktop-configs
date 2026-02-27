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
    ]
    ++ (lib.optional (builtins.pathExists ../../machines/${hostname}/hardware-configuration.nix) ../../machines/${hostname}/hardware-configuration.nix);

    system.stateVersion = "25.11";
    nix.settings.experimental-features = ["nix-command" "flakes"];
}
