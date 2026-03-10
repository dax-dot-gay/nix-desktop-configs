{ nix-flatpak, ... }:
{
    imports = [
        nix-flatpak.nixosModules.nix-flatpak
    ];
    services.flatpak = {
        enable = true;
        packages = [
            "com.github.Matoking.protontricks"
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
