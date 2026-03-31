{
    config,
    hostname,
    ...
}:
{
    flake.secrets.global."tailscale/keys/${hostname}" = { };
    services.tailscale = {
        enable = true;
        authKeyFile = config.sops.secrets."tailscale/keys/${hostname}".path;
        extraUpFlags = [ "--advertise-exit-node" ];
    };
    networking.nftables.enable = true;
    systemd.services.tailscaled.serviceConfig.Environment = [
        "TS_DEBUG_FIREWALL_MODE=nftables"
    ];
    systemd.network.wait-online.enable = false;
    boot.initrd.systemd.network.wait-online.enable = false;
}
