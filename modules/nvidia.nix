{ config, pkgs, lib, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
    nvidiaSettings = true;
    # Track kernelPackages (linuxPackages_zen) via config rather than a
    # hardcoded pkgs.* reference, and pin to the "production" branch instead
    # of "latest" (New Feature Branch) — production trades bleeding-edge
    # features for a longer-tested driver, after the 595.x flicker/freeze
    # regression on the New Feature Branch.
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Forces KWin to bind to the NVIDIA GPU (/dev/dri/card1) instead of the
  # AMD iGPU (/dev/dri/card0), which previously caused a KWin crash-loop.
  # /dev/dri/cardN enumeration order is NOT guaranteed stable across kernel
  # or driver updates. If KWin crash-loops again after an update, check
  # `udevadm info /dev/dri/card*` (look for the NVIDIA vs AMD driver in the
  # output) to see whether the index has shifted, and update this value.
  environment.sessionVariables = {
    KWIN_DRM_DEVICES = "/dev/dri/card1";
  };
}
