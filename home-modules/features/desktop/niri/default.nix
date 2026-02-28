{ ... }:
{
    imports = [
        ./io.nix
    ];
    wayland.windowManager.niri = {
        enable = true;
        package = null;
    };
}
