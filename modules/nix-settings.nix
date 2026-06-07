{ config, pkgs, lib, ... }:

{
  # Garbage collection and scheduled cleanup
  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    dates = "weekly";
    options = "--delete-older-than 10d";
  };
  # Nix settings and caches
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
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

  # System auto upgrade disabled - rely on flake for version management
  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;
}
