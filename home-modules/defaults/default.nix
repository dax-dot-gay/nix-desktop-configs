{ stateVersion, lib, ... }:
{
    imports = [
        ./homeinfo.nix
    ];
    home.stateVersion = stateVersion;
    nixpkgs.config = lib.mkForce null;
    nixpkgs.overlays = lib.mkForce null;
}
