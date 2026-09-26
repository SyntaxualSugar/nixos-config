{ config, pkgs, lib, ... }:

{
  # Use tmpfs for /tmp to reduce disk I/O
  fileSystems."/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "mode=1777" "size=20%" ];
  };

  # Kernel VM tuning + networking
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
    # Disable IPv6 forwarding on WiFi to prevent p2p device errors
    "net.ipv6.conf.all.forwarding" = 0;
    "net.ipv6.conf.default.forwarding" = 0;
  };

  # Limit journald disk usage to avoid filling disks and causing stalls.
  # services.journald.extraConfig was removed upstream (now a hard
  # assertion, not just a warning) in favor of services.journald.settings.
  services.journald.settings.Journal = {
    SystemMaxUse = "200M";
    SystemKeepFree = "50M";
    SystemMaxFileSize = "20M";
  };
}
