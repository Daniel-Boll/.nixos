{
  description = "Home flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
  };

  outputs = {self, nixpkgs, home-manager, stylix}:
  let
    lib = nixpkgs.lib;
    home-lib = home-manager.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      danielboll-nixos = lib.nixosSystem {
        inherit system;
        modules = [ ./system/configuration.nix ];
        specialArgs = { inherit stylix; };
      };
    };
    homeConfigurations = {
      danielboll = home-lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit stylix; };
      };
    };
  };
}
