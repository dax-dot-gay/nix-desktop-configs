{ ... }:
{
    systemd.user.services.niri-flake-polkit.enable = false;
    imports = [
        ./io.nix
    ];
    programs.niri.enable = true;
}
