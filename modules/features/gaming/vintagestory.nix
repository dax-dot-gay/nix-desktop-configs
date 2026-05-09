{ vintagestory-nix, ... }:
{
    nixpkgs.overlays = [ vintagestory-nix.overlays.default ];
}
