{ config, pkgs, lib, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
    nvidiaSettings = true;
    package = pkgs.linuxPackages_zen.nvidiaPackages.latest;
  };

  environment.sessionVariables = {
    KWIN_DRM_DEVICES = "/dev/dri/card1";
  };
}