{ pkgs, vintagestory-nix, ... }:
{
    imports = [ vintagestory-nix.homeModules.default ];
    home.packages = with pkgs; [
        vintagestoryPackages.rustique
        vintagestoryPackages.vs-launcher
    ];
    programs.vs-launcher = {
        enable = true;
        settings.gameVersions = [
            pkgs.vintagestoryPackages.latest
        ];
    };
}
