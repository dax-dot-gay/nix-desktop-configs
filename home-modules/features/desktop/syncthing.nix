{ ... }:
{
    services.syncthing = {
        enable = true;
        passwordFile = "/run/secrets/syncthing/password";
        tray.enable = true;
    };
}
