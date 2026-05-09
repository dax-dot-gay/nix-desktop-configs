{ pkgs, vintagestory-nix, ... }:
{
    imports = [ vintagestory-nix.homeModules.default ];
    home.packages = with pkgs; [
        vintagestoryPackages.rustique
        vintagestoryPackages.vs-launcher
        vintagestoryPackages.latest
    ];
    programs.vs-launcher = {
        enable = true;
        settings.gameVersions = [
            pkgs.vintagestoryPackages.v1-22-2
            pkgs.vintagestoryPackages.v1-22-0
        ];
    };
}
