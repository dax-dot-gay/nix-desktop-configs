{
    description = "Unified configurations for my desktop/bare-metal systems";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        disko = {
            url = "github:nix-community/disko/latest";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nirix = {
            url = "github:dax-dot-gay/nirix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        dms = {
            url = "github:AvengeMedia/DankMaterialShell/stable";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        catppuccin = {
            url = "github:catppuccin/nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        dms-plugin-registry = {
            url = "github:AvengeMedia/dms-plugin-registry";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-monitor = {
            url = "github:antonjah/nix-monitor";
        };

        # Basing some of this off https://github.com/nficca/nixos-config
        niri-wip = {
            url = "github:niri-wm/niri/wip/branch";
            inputs.nixpkgs.follows = "nixpkgs";

            # https://github.com/niri-wm/niri/blob/2dc6f4482c4eeed75ea8b133d89cad8658d38429/flake.nix#L8-L9
            inputs.rust-overlay.follows = "";
        };
        nix-vscode-extensions = {
            url = "github:nix-community/nix-vscode-extensions";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        stylix = {
            url = "github:nix-community/stylix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nur = {
            url = "github:nix-community/NUR";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        comin = {
            url = "github:nlewo/comin";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        awww = {
            url = "git+https://codeberg.org/LGFae/awww";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs =
        {
            self,
            nixpkgs,
            ...
        }@inputs:
        let
            system = "x86_64-linux";
            utilities = import ./utils;

            mkMachine =
                {
                    hostname,
                    flakes ? [ ],
                    features ? [ ],
                    home-flakes ? [ ],
                    home-features ? [ ],
                }:
                nixpkgs.lib.nixosSystem {
                    system = "${system}";
                    specialArgs = inputs // {
                        hostname = "${hostname}";
                        utilities = utilities;
                        hm_args = {
                            inputs = inputs;
                            home-flakes = home-flakes;
                            home-features = home-features;
                        };
                    };
                    modules = [
                        ./modules/defaults
                        ./machines/${hostname}/configuration.nix
                        inputs.home-manager.nixosModules.home-manager
                        inputs.disko.nixosModules.disko
                        inputs.sops-nix.nixosModules.sops
                        inputs.comin.nixosModules.comin
                    ]
                    ++ flakes
                    ++ (map (feature: ./modules/features/${feature}) features);
                };
        in
        {
            nixosConfigurations = {
                testbed = mkMachine {
                    hostname = "testbed";
                    features = [ "desktop" ];
                    home-features = [ "desktop" ];
                };
                stryker = mkMachine {
                    hostname = "stryker";
                    features = [ "desktop" "multimedia" "nitrokey" "gaming" ];
                    home-features = [ "desktop" ];
                };
            };
        };
}
