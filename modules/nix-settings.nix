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
    # Removed the SJTU (Shanghai) mirror: it's signed by the same key as
    # cache.nixos.org (no separate trusted-public-key needed), but being
    # geographically distant from Arkansas means a slow/unreachable response
    # eats into the connect-timeout below on every cache miss instead of
    # falling straight through to cache.nixos.org.
    substituters = [
      "https://comfyui.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "comfyui.cachix.org-1:33mf9VzoIjzVbp0zwj+fT51HG0y31ZTK3nzYZAX0rec="
      "nix-community.cachix.org-1:mB9FSh9qf2QlZceNJC6f1tG3NG8sDKJjRN7sFAg5UZs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
    max-jobs = "auto";
    cores = 0;
    # Increase HTTP connection pool to handle slow mirrors better
    connect-timeout = 60;
    http-connections = 128;
  };

  # System auto upgrade disabled - rely on flake for version management
  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;
}
