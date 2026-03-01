{ hostname, ... }:
{
    programs.dank-material-shell = {
        enable = true;
        enableCalendarEvents = false;
        plugins = {
            nixMonitor.enable = true;
            niriScreenshot.enable = true;
            tailscale.enable = true;
            displayOutput.enable = true;
            displayManager.enable = true;
        };
        session = {
            showThirdPartyPlugins = true;
            weatherLocation = "Rochester, NY";
        };
    };
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
