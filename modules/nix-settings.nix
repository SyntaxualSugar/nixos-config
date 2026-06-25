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
      # CUDA-specific caches first (highest priority for your workload)
      "https://cuda-maintainers.cachix.org"
      # Community and AI caches
      "https://nix-community.cachix.org"
      "https://ai.cachix.org"
      "https://nix-gaming.cachix.org"
      # Primary mirrors - geographically diverse and reliable
      "https://cache.nixos.org"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNAco0="
      "nix-community.cachix.org-1:mB9FSh9qf2QlZceNJC6f1tG3NG8sDKJjRN7sFAg5UZs="
      "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
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
