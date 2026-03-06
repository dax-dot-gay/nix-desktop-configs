{ hostname, ... }:
{
    networking = {
        networkmanager.enable = true;
        networkmanager.dhcp = "internal";
        hostName = hostname;
        firewall.enable = false;
        dhcpcd.enable = false;
    };
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
}
