{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.system-configuration;

  usersSubmodule = types.submodule (
    { config, ... }:
    {
      username = mkOption {
        type = types.str;
        default = config._module.args.name;
        description = "Name of this user";
      };
      superuser = mkOption {
        type = types.bool;
        default = false;
        description = "Whether this user should be able to sudo";
      };
    }
  );
in
{
  options.system-configuration = {
    enable = mkEnableOption "Simplified system configuration";
    root_disk = mkOption {
      type = types.str;
      description = "Path to the disk to set up as the root filesystem.";
      example = "/dev/disk/by-id/some-disk-id";
    };
    users = mkOption {
      type = types.attrsOf usersSubmodule;
      default = { };
      description = "Set of system users to create";
    };
  };

  config = mkIf cfg.enable {
    disko.devices.disk.root = {
      device = mkDefault cfg.root_disk;

    };
    users.users = lib.mapAttrs (name: value: {
      name = value.username;
      group = value.username;
      extraGroups = if value.superuser then [ "wheel" ] else [ ];
    }) cfg.users;
  };
}
