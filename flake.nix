{
    description = "Unified configurations for my desktop/bare-metal systems";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
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
        stylix = {
           url = "github:nix-community/stylix";
           inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs =
        { self, nixpkgs, ... }@inputs:
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
                    };
                    modules = [
                        ./modules/defaults
                        ./machines/${hostname}/configuration.nix
                        inputs.home-manager.nixosModules.home-manager
                        inputs.disko.nixosModules.disko
                        inputs.sops-nix.nixosModules.sops
                        {
                            #hardware.facter.reportPath = ./machines/${hostname}/facter.json;
                            home-manager = {
                                useGlobalPkgs = true;
                                useUserPkgs = true;
                                users.${utilities.config.username} = ./machines/${hostname}/home.nix;
                                extraSpecialArgs = inputs // {
                                    hostname = "${hostname}";
                                    utilities = utilities;
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
