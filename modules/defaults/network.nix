{ hostname, ... }:
{
    networking = {
        networkmanager.enable = true;
        hostName = hostname;
        firewall.enable = false;
    };
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
}
