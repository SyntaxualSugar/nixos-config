{ config, pkgs, lib, ... }:

{
  # Garbage collection and scheduled cleanup
  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    dates = "weekly";
    options = "--delete-older-than 10d";
  };
  nix.settings.auto-optimize-store = true;

  # Nix settings and caches
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-gaming.cachix.org"
      "https://ai.cachix.org"
    ];
    trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
    ];
    max-jobs = "auto";
    cores = 0;
  };

  # Allow unfree packages consistently from one place
  nixpkgs.config.allowUnfree = true;

  # System auto upgrade defaults (kept here to centralize nix-related settings)
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
}
