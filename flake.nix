{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    claude-desktop = {
      url = "github:aaddrick/claude-desktop-debian";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NOT following root nixpkgs: mcp-nixos builds its own Python packages
    # (e.g. fastmcp-slim) with build logic tied to its pinned nixpkgs
    # snapshot. Following root nixpkgs broke that build (source archive
    # layout mismatch in the unpack phase). Update deliberately via
    # `nix flake update mcp-nixos` and test before relying on it.
    mcp-nixos.url = "github:utensils/mcp-nixos";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NOT following root nixpkgs here on purpose: comfyui-nix pins CUDA/
    # PyTorch derivations (e.g. kornia-rs) that are only cached against its
    # own nixpkgs snapshot. Following root nixpkgs breaks that cache hit and
    # forces multi-GB CUDA packages to build from source. Update this input
    # deliberately (nix flake update comfyui-nix) when you're ready to eat
    # that rebuild, not as a side effect of an unrelated flake.nix change.
    comfyui-nix.url = "github:utensils/comfyui-nix";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, comfyui-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgsStable = import nixpkgs-stable {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "electron-25.9.0"
            "ventoy-qt5-1.1.12"
          ];
        };
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgsStable; };
        modules = [
          ./configuration.nix
          inputs.home-manager.nixosModules.default
          inputs.comfyui-nix.nixosModules.default
        ];
      };

      # `nix fmt` formats the whole tree with nixpkgs-fmt.
      formatter.${system} = pkgs.nixpkgs-fmt;

      # `nix flake check` runs these automatically, locally and in CI —
      # single source of truth instead of duplicating tool invocations
      # in a workflow file.
      checks.${system} = {
        nixpkgs-fmt = pkgs.runCommand "check-nixpkgs-fmt" { nativeBuildInputs = [ pkgs.nixpkgs-fmt ]; } ''
          nixpkgs-fmt --check ${self}
          touch $out
        '';
        statix = pkgs.runCommand "check-statix" { nativeBuildInputs = [ pkgs.statix ]; } ''
          statix check --config ${self} ${self}
          touch $out
        '';
        deadnix = pkgs.runCommand "check-deadnix" { nativeBuildInputs = [ pkgs.deadnix ]; } ''
          deadnix --fail --no-lambda-pattern-names ${self}
          touch $out
        '';
      };
    };
}
