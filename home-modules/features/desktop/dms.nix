{ ... }:
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
    };
    programs.nix-monitor = {
        enable = true;
        rebuildCommand = [ "/usr/bin/env" "zsh" "-c" "comin fetch" ];
        generationsCommand = [ "/usr/bin/env" "zsh" "-c" "cat /run/sysinfo/count-generations" ];
        gcCommand = ["/usr/bin/env" "zsh" "-c" "pkexec nix-collect-garbage -d"];
        nixpkgsChannel = "nixos-unstable";
    };
    home.file.".config/DankMaterialShell/themes/catppuccin/theme.json".source = ./catppuccin.json;
}
