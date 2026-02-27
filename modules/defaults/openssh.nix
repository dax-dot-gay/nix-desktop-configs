{ lib, config, ... }:
with lib;
let
    cfg = config.flake.openssh;
in
{
    options.flake.openssh = {
        enable = mkEnableOption "Enable unified SSH configuration";
        sftp = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to allow SFTP connections (defaults to false)";
        };
        x11 = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to allow X11 forwarding (defaults to false)";
        };
    };
    config = {
        services.openssh = mkIf cfg.enable {
            enable = true;
            allowSFTP = cfg.sftp;
            settings = {
                PermitRootLogin = "no";
                PasswordAuthentication = false;
                X11Forwarding = cfg.x11;
            };
        };
    };
}
