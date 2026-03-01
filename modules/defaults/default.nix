{
    lib,
    hostname,
    nur,
    ...
}:
{
    imports = [
        ./boot.nix
        ./system.nix
        ./secrets.nix
        ./network.nix
        ./openssh.nix
        ./shell.nix
        ../../machines/${hostname}/auto.nix
    ];

    hardware.facter.reportPath = lib.mkIf (builtins.pathExists ../../machines/${hostname}/facter.json) ../../machines/${hostname}/facter.json;
    system.stateVersion = "25.11";
    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];
    nixpkgs.overlays = [
        nur.overlays.default
    ];
}
