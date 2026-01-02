{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgsStable = import nixpkgs-stable { inherit system; config.allowUnfree = true; };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgsStable; };
        modules = [
          ./configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
}
