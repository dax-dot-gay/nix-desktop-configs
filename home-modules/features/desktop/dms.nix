{ pkgs, ... }:
{
    programs.dank-material-shell = {
        enable = true;
        enableCalendarEvents = false;
        plugins = {
            nixMonitor.enable = true;
            niriScreenshot.enable = true;
            tailscale.enable = true;
            displayManager.enable = true;
            dankAudioVisualizer.enable = true;
            amdGpuMonitorRevive.enable = true;
            clipboardPlus.enable = true;
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
    home.packages = [pkgs.amdgpu_top pkgs.kdePackages.qt5compat];
}
