{ config, pkgs, lib, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
    nvidiaSettings = true;
    # Tracks the "latest" (New Feature Branch) driver, matching what was
    # running stably before 2026-07-20. Earlier that day a "production"
    # branch experiment (595.84, down from 610.43.x) was blamed for two
    # intermittent boot hangs, but journalctl later showed the driver,
    # CUDA, and SDDM all initialized fine on both failed boots — the real
    # cause was the DRM device race documented below, unrelated to this
    # branch choice. No evidence either branch is unsafe on this system;
    # staying on "latest" simply because that's the known-stable baseline.
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  # Custom udev rule creates a stable, colon-free symlink to the NVIDIA
  # card, keyed on PCI vendor ID (0x10de = NVIDIA) rather than a cardN
  # index (enumeration order vs. amdgpu is a boot-time race, not
  # guaranteed stable) or a /dev/dri/by-path/* symlink (those names embed
  # the PCI address in bus:device.function form, e.g.
  # "pci-0000:01:00.0-card" — and KWIN_DRM_DEVICES splits its value on
  # colons, so that literally-correct path got parsed as three garbage
  # paths and crashed KWin outright on 2026-07-21, confirmed via
  # journalctl -b -5: "kwin_wayland_drm: Failed to open drm device
  # /dev/dri/by-path/pci-0000" / "...01" / "...00.0-card", then a SIGSEGV).
  services.udev.extraRules = ''
    SUBSYSTEM=="drm", KERNEL=="card*", ATTRS{vendor}=="0x10de", SYMLINK+="dri/nvidia-card"
  '';

  environment.sessionVariables = {
    KWIN_DRM_DEVICES = "/dev/dri/nvidia-card";
  };
}
