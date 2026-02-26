{ ... }:
{
    imports = [
        ./boot.nix
        ./system.nix
        ./secrets.nix
    ];

    system.stateVersion = "25.11";
}
