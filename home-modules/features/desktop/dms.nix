{ ... }:
{
    programs.dank-material-shell = {
        enable = true;
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
        niri.includes.enable = false;
    };
}
