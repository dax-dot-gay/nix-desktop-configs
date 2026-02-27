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
        niri-flake = {
            url = "github:sodiboo/niri-flake";
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
    };

    outputs =
        {
            self,
            nixpkgs,
            ...
        }@inputs:
        let
            system = "x86_64-linux";
            pkgs = import nixpkgs { inherit system; };
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
                        inputs.niri-flake.nixosModules.niri
                        inputs.dms.nixosModules.dank-material-shell
                        inputs.catppuccin.nixosModules.catppuccin
                    ]
                    ++ flakes
                    ++ (map (feature: ./modules/features/${feature}) features);
                };
        in
        {
            nixosConfigurations = {
                testbed = mkMachine {
                    hostname = "testbed";
                };
            };
        };
}
