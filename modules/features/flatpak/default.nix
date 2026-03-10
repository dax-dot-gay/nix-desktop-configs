{ nix-flatpak, ... }:
{
    imports = [
        nix-flatpak.nixosModules.nix-flatpak
    ];
    services.flatpak = {
        enable = true;
        packages = [
            "io.github.limo_app.limo"
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
