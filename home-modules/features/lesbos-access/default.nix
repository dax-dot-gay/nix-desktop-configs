{ config, ... }:
{
    services.trayscale.enable = true;
    programs.ssh = {
        enable = true;
        matchBlocks.lesbos = {
            host = "192.168.30.*";
            identityFile = "/home/${config.homeflake.info.username}/.ssh/id_ed25519.lesbos";
        };
    };
}
