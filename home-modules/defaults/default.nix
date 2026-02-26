{ stateVersion, lib, ... }:
{
    imports = [];
    home.stateVersion = stateVersion;
    nixpkgs.config = lib.mkForce null;
    nixpkgs.overlays = lib.mkForce null;
}
