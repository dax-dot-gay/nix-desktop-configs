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

    usersSubmodule = types.submodule (
        { config, ... }:
        {
            options = {
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
                allowSystemConfiguration = mkOption {
                    type = types.bool;
                    default = false;
                    description = ''
                        Whether this user should be set up to be able to modify the system configuration & associated repository.
                        This does a few things:
                        - Grants access to and enables my primary SSH key (secrets."ssh/keys/dax/..") for this user
                        - Adds the user to the "nixos-config" group
                        - Links the system configuration into ~/.config/nixos-config
                        - Implies `superuser`
                    '';
                };
                shell = mkOption {
                    type = types.nullOr (types.either types.path types.shellPackage);
                    default = null;
                    description = "Package of user shell, if different from the system default.";
                };
                groups = mkOption {
                    type = types.listOf types.str;
                    default = [ ];
                    description = "Extra groups to add (does not create groups)";
                };
                _actual_superuser = mkOption {
                    type = types.bool;
                    default =
                        cfg.users.${config._module.args.name}.superuser
                        || cfg.users.${config._module.args.name}.allowSystemConfiguration;
                    description = "Merges superuser and allowSystemConfiguration to imply superuser. DO NOT SET.";
                };
            };
        }
    );
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
            type = types.attrsOf usersSubmodule;
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
            default = pkgs.zsh;
            description = "Default system shell";
        };
        stateVersion = mkOption {
            type = types.str;
            description = "Nix channel version";
        };
    };

    config = mkIf cfg.enable {
        disko.devices =
            if cfg.encryption then
                {
                    disk.root = {
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
                                luks = {
                                    size = "100%";
                                    content = {
                                        type = "luks";
                                        name = "cryptroot";
                                        extraOpenArgs = [ ];
                                        settings = {
                                            allowDiscards = true;
                                        };
                                        content = {
                                            type = "lvm_pv";
                                            vg = "pool";
                                        };
                                    };
                                };
                            };
                        };
                    };
                    lvm_vg.pool = {
                        type = "lvm_vg";
                        lvs = {
                            root = {
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
                }
            else
                {
                    disk.root = {
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
                                lvm = {
                                    size = "100%";
                                    content = {
                                        type = "lvm_pv";
                                        vg = "pool";
                                    };
                                };
                            };
                        };
                    };
                    lvm_vg.pool = {
                        type = "lvm_vg";
                        lvs = {
                            root = {
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

        flake.secrets.global."ssh/authorized_keys/dax" = { };
        flake.secrets.global."ssh/keys/dax/public" = {
            owner = "root";
            group = "nixos-config";
            mode = "660";
        };
        flake.secrets.global."ssh/keys/dax/private" = {
            owner = "root";
            group = "nixos-config";
            mode = "660";
        };
        users.users = lib.mapAttrs (name: value: {
            name = value.username;
            group = value.username;
            extraGroups =
                (optional value._actual_superuser "wheel")
                ++ (optional value.allowSystemConfiguration "nixos-config")
                ++ value.groups;
            hashedPasswordFile = config.sops.secrets."users/${value.username}/password".path;
            createHome = true;
            shell = if isNull value.shell then cfg.defaultShell else value.shell;
            isNormalUser = true;
            openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAiAboVZPRR/NJirG0zeB3SBdOYzJ1n3/kYKKRDGu3wq dax@dax.gay"
            ];
        }) cfg.users;
        users.groups = (lib.mapAttrs (name: value: { name = value.username; }) cfg.users) // {
            nixos-config = {
                gid = 101;
            };
        };
        users.defaultUserShell = cfg.defaultShell;

        flake.secrets.local = listToAttrs (
            lib.mapAttrsToList (name: value: {
                name = "users/${value.username}/password";
                value = {
                    neededForUsers = true;
                };
            }) cfg.users
        );
        system.stateVersion = cfg.stateVersion;

        systemd.services.allow-system-configuration = {
            enable = true;
            after = ["network.target"];
            wantedBy = ["default.target"];
            script = concatStringsSep "\n" (
            map (user: ''
                echo "Provisioning ${user.username}..."
                mkdir /home/${user.username}/.ssh
                chmod -R 700 /home/${user.username}/.ssh
                cp ${config.sops.secrets."ssh/keys/dax/private".path} /home/${user.username}/.ssh/id_ed25519
                cp ${config.sops.secrets."ssh/keys/dax/public".path} /home/${user.username}/.ssh/id_ed25519.pub
                chmod 600 /home/${user.username}/.ssh/id_ed25519
                chmod 644 /home/${user.username}/.ssh/id_ed25519.pub
                chown -R ${user.username}:${user.username} /home/${user.username}/.ssh
                mkdir -p /home/${user.username}/.config
                chown ${user.username}:${user.username} /home/${user.username}/.config
                ln -s /etc/nixos /home/${user.username}/.config/nixos-config
                echo "---"
                echo
            '') (attrValues (filterAttrs (name: value: value.allowSystemConfiguration) cfg.users)));
            serviceConfig = { 
                Type = "oneshot";
                DynamicUser = "no";
                User = "root";
                Group = "root";
             };
        };

        boot.loader.limine.secureBoot.enable = cfg.secureboot;
        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users = mapAttrs (
                name: value:
                { ... }:
                {
                    imports = [
                        ../../machines/${hostname}/users/${value.username}/home.nix
                    ];
                    homeflake.info = {
                        username = value.username;
                        superuser = value._actual_superuser;
                        shell = if isNull value.shell then cfg.defaultShell else value.shell;
                        groups = [
                            value.username
                        ]
                        ++ (optional value._actual_superuser "wheel")
                        ++ (optional value.allowSystemConfiguration "nixos-config")
                        ++ value.groups;
                        systemConfigurationAllowed = value.allowSystemConfiguration;
                    };
                }
            ) cfg.users;
            extraSpecialArgs = hm_args.inputs // {
                hostname = "${hostname}";
                utilities = utilities;
                stateVersion = cfg.stateVersion;
            };
            sharedModules = [
                ../../home-modules/defaults
            ]
            ++ hm_args.home-flakes
            ++ (map (feature: ../../home-modules/features/${feature}) hm_args.home-features);
        };
    };
}
