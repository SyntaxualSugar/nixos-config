{ config, pkgs, lib, ... }:

{
  # Centralized place for system-wide packages. Keep small — prefer home.packages
  environment.systemPackages = with pkgs; [
    btrfs-progs
    canon-cups-ufr2
    kdePackages.bluedevil
    localsend
    networkmanager-openvpn
    wireguard-tools
  ];
}
