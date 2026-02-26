{
    pkgs,
    lib,
    config,
    utilities,
    hostname,
    hm_args,
    ...
}:
with lib;
let
    cfg = config.flake.system-configuration;
in
{
    options.flake.system-configuration = {
        enable = mkEnableOption "Simplified system configuration";
        root_disk = mkOption {
            type = types.str;
            description = "Path to the disk to set up as the root filesystem.";
            example = "/dev/disk/by-id/some-disk-id";
        };
        encryption = mkOption {
            type = types.bool;
            default = true;
            description = "Whether to encrypt the root filesystem (btrfs on luks)";
        };
        users = mkOption {
            type = types.attrsOf (types.submodule (
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
                    shell = mkOption {
                        type = types.nullOr (types.either types.path types.shellPackage);
                        default = null;
                        description = "Package of user shell, if different from the system default.";
                    };
                }
            ));
            default = { };
            description = "Set of users to create";
        };
        swapsize = mkOption {
            type = types.str;
            default = "20M";
            description = "Size of the swapfile (should be made larger to enable hibernation)";
        };
        secureboot = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to enable secureboot. Key enrollment should be done before this is enabled.";
        };
        defaultShell = mkOption {
            type = types.either types.path types.shellPackage;
            default = pkgs.bashInteractive;
            description = "Default system shell";
        };
    };

    config = mkIf cfg.enable {
        environment.systemPackages = [ pkgs.sbctl ];
        services.openssh.authorizedKeysFiles = [ config.sops.secrets."ssh/authorized_keys".path ];
        disko.devices.disk.root = {
            device = mkDefault cfg.root_disk;
            type = "disk";
            content = {
                type = "gpt";
                partitions = {
                    ESP = {
                        size = "1G";
                        type = "EF00";
                        content = {
                            type = "filesystem";
                            format = "vfat";
                            mountpoint = "/boot";
                            mountOptions = [ "umask=0077" ];
                        };
                    };
                    luks = mkIf cfg.encryption {
                        size = "100%";
                        content = {
                            type = "luks";
                            name = "crypt-root";
                            passwordFile = "/tmp/disk.key";
                            settings = {
                                allowDiscards = true;
                            };
                            content = {
                                type = "btrfs";
                                extraArgs = [ "-f" ];
                                subvolumes = {
                                    "/root" = {
                                        mountpoint = "/";
                                        mountOptions = [
                                            "compress=zstd"
                                            "noatime"
                                        ];
                                    };
                                    "/home" = {
                                        mountpoint = "/home";
                                        mountOptions = [
                                            "compress=zstd"
                                            "noatime"
                                        ];
                                    };
                                    "/nix" = {
                                        mountpoint = "/nix";
                                        mountOptions = [
                                            "compress=zstd"
                                            "noatime"
                                        ];
                                    };
                                    "/swap" = {
                                        mountpoint = "/.swapvol";
                                        swap.swapfile.size = cfg.swapsize;
                                    };
                                };
                            };
                        };
                    };
                    noluks = mkIf (!cfg.encryption) {
                        size = "100%";
                        content = {
                            type = "btrfs";
                            extraArgs = [ "-f" ];
                            subvolumes = {
                                "/root" = {
                                    mountpoint = "/";
                                    mountOptions = [
                                        "compress=zstd"
                                        "noatime"
                                    ];
                                };
                                "/home" = {
                                    mountpoint = "/home";
                                    mountOptions = [
                                        "compress=zstd"
                                        "noatime"
                                    ];
                                };
                                "/nix" = {
                                    mountpoint = "/nix";
                                    mountOptions = [
                                        "compress=zstd"
                                        "noatime"
                                    ];
                                };
                                "/swap" = {
                                    mountpoint = "/.swapvol";
                                    swap.swapfile.size = cfg.swapsize;
                                };
                            };
                        };
                    };
                };
            };
        };
        users.users = lib.mapAttrs (name: value: {
            name = value.username;
            group = value.username;
            extraGroups = if value.superuser then [ "wheel" ] else [ ];
            hashedPasswordFile = config.sops.secrets."users/${value.username}/password".path;
            createHome = true;
            shell = value.shell;
            useDefaultShell = isNull value.shell;
        }) cfg.users;
        users.defaultUserShell = cfg.defaultShell;

        flake.secrets.local = listToAttrs (
            lib.mapAttrsToList (name: value: {
                name = "users/${value.username}/password";
                value = {
                    neededForUsers = true;
                };
            }) cfg.users
        );
        flake.secrets.global."ssh/authorized_keys" = { };

        boot.loader.limine.secureBoot.enable = cfg.secureboot;
        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users = mapAttrs (name: value: ../../machines/users/${value.username}/home.nix) cfg.users;
            extraSpecialArgs = hm_args.inputs // {
                hostname = "${hostname}";
                utilities = utilities;
            };
            sharedModules = [
                ../../home-modules/defaults
            ]
            ++ hm_args.home-flakes
            ++ (map (feature: ../../home-modules/features/${feature}) hm_args.home-features);
        };
    };
}
