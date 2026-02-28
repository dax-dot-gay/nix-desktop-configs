{ hostname, pkgs, ... }:
{
    programs.dank-material-shell = {
        enable = true;
        systemd = {
            enable = true;
            restartIfChanged = true;
        };

        enableSystemMonitoring = true;
        enableVPN = true;
        enableAudioWavelength = true;
        enableCalendarEvents = true;
        enableClipboardPaste = true;
        enableDynamicTheming = false;
        greeter = {
            enable = true;
            compositor.name = "niri";
        };
    };

    environment.systemPackages = with pkgs; [
        tailscale
        ddcutil
        pavucontrol
        socat
    ];

    programs.nix-monitor = {
        enable = true;
        rebuildCommand = [
            "zsh"
            "-c"
            "pkexec nixos-rebuild switch --flake /etc/nixos/#${hostname} 2>&1"
        ];
        nixpkgsChannel = "nixos-unstable";
    };
}
