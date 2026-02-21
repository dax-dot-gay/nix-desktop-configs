let
    utils = import ./utils;
in
{
    description = "Unified configurations for my desktop/bare-metal systems";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = utils.flakes.include "github:nix-community/home-manager";
        disko = utils.flakes.include "github:nix-community/disko/latest";
        sops-nix = utils.flakes.include "github:Mic92/sops-nix";
        niri-flake = utils.flakes.include "github:sodiboo/niri-flake";
        dms = utils.flakes.include "github:AvengeMedia/DankMaterialShell/stable";
        stylix = utils.flakes.include "github:nix-community/stylix";
    };

    outputs =
        { self, nixpkgs, ... }@inputs:
        let
            system = "x86_64-linux";
            pkgs = import nixpkgs { inherit system; };

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
                        utils = utils;
                    };
                    modules = [
                        ./modules/defaults
                        ./machines/${hostname}/configuration.nix
                        inputs.home-manager.nixosModules.home-manager
                        inputs.disko.nixosModules.disko
                        inputs.sops-nix.nixosModules.sops
                        {
                            hardware.facter.reportPath = ./machines/${hostname}/facter.json;
                            home-manager = {
                                useGlobalPkgs = true;
                                useUserPkgs = true;
                                users.${utils.config.username} = ./machines/${hostname}/home.nix;
                                extraSpecialArgs = inputs // {
                                    hostname = "${hostname}";
                                    utils = utils;
                                };
                                sharedModules = [
                                    ./home-modules/defaults
                                ]
                                ++ home-flakes
                                ++ (map (feature: ./home-modules/features/${feature}) home-features);
                            };
                        }
                    ]
                    ++ flakes
                    ++ (map (feature: ./modules/features/${feature}) features);
                };
        in
        {
            nixosConfigurations = {
                testbed = mkMachine {
                    hostname = "testbed";
                    flakes = with inputs; [
                        niri-flake.nixosModules.niri
                        dms.nixosModules.dank-material-shell
                        stylix.nixosModules.stylix
                    ];
                    home-flakes = with inputs; [
                        stylix.homeModules.stylix
                        sops-nix.homeManagerModules.sops
                        dms.homeModules.dank-material-shell
                    ];
                };
            };
        };
}
