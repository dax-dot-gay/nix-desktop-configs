{ lib, ... }:
with lib;
{
    # All of this information is set automatically in options.flake.system-configuration
    options.homeflake.info = {
        username = mkOption {
            type = types.str;
            description = "Username in this home config (set automatically)";
        };
        superuser = mkOption {
            type = types.bool;
            description = "Whether this user is a superuser (set automatically)";
        };
        shell = mkOption {
            type = types.either types.path types.shellPackage;
            description = "Package of user shell (set automatically)";
        };
        groups = mkOption {
            type = types.listOf types.str;
            description = "List of groups this user belongs to (set automatically)";
        };
        systemConfigurationAllowed = mkOption {
            type = types.bool;
            description = "Whether this user can modify the system configuration (set automatically)";
        };
    };
}
