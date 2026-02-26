{ stateVersion, ... }:
{
    imports = [];
    home.stateVersion = stateVersion;
    nixpkgs.config = null;
    nixpkgs.overlays = null;
}
