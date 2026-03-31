{
    config,
    hostname,
    ...
}:
{ 
    flake.secrets.global."tailscale/keys/${hostname}" = {};
    services.tailscale = {
        enable = true;
        authKeyFile = config.sops.secrets."tailscale/keys/${hostname}".path;
    };
}
