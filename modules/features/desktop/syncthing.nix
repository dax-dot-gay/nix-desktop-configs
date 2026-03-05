{ ... }:
{
    flake.secrets.global."syncthing/password" = {
        owner = "root";
        group = "root";
        mode = "644";
    };
}
