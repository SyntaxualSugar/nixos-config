{ config, pkgs, lib, ... }:

{
  # Display manager and Plasma desktop configuration
  services.displayManager.sddm.enable = lib.mkDefault true;
  services.displayManager.sddm.wayland.enable = lib.mkDefault true;
  services.desktopManager.plasma6.enable = lib.mkDefault true;
}
