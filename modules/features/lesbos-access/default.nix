{
    ...
}:
{
    services.tailscale = {
        enable = true;
    };
    networking.nftables.enable = true;
    systemd.services.tailscaled.serviceConfig.Environment = [
        "TS_DEBUG_FIREWALL_MODE=nftables"
    ];
    systemd.network.wait-online.enable = false;
    boot.initrd.systemd.network.wait-online.enable = false;
}
