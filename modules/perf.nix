{ config, pkgs, lib, ... }:

{
  # Use tmpfs for /tmp to reduce disk I/O
  fileSystems."/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "mode=1777" "size=20%" ];
  };

  # Kernel VM tuning
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
  };

  # Limit journald disk usage to avoid filling disks and causing stalls
  services.journald.extraConfig = ''
    SystemMaxUse=200M
    SystemKeepFree=50M
    SystemMaxFileSize=20M
  '';

  # Enable preload
  services.preload.enable = true;

  # Enable PDNSD
  services.pdnsd.enable = true;
}
