{ pkgs, ... }:
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
        enableCalendarEvents = false;
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
}
