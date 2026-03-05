{ hostname, ... }:
{
    networking = {
        networkmanager.enable = true;
        hostName = hostname;
    };
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    services.network-manager-applet.enable = true;
}
