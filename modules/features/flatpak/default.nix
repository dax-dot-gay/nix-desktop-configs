{ nix-flatpak, ... }:
{
    imports = [
        nix-flatpak.nixosModules.nix-flatpak
    ];
    services.flatpak = {
        enable = true;
        packages = [
        ];
        overrides = {
            global = {
                Context.filesystems = [
                    "/run/current-system/sw/bin:ro"
                    "/mnt/data:rw"
                ];
            };
        };
    };
}
