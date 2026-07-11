{ config, pkgs, lib, ... }:

{
  # Display manager and Plasma desktop configuration
  services.displayManager.sddm.enable = lib.mkDefault true;
  services.displayManager.sddm.wayland.enable = lib.mkDefault true;
  services.desktopManager.plasma6.enable = lib.mkDefault true;
  security.pam.services.sddm.kwallet.enable = true;

  systemd.services.sync-sddm-screen-config = {
  description = "Sync KWin output config to SDDM greeter";
  serviceConfig.Type = "oneshot";
  script = ''
    mkdir -p /var/lib/sddm/.config
    cp /home/trenton/.config/kwinoutputconfig.json /var/lib/sddm/.config/kwinoutputconfig.json
    chown sddm:sddm /var/lib/sddm/.config/kwinoutputconfig.json
  '';
  };

  systemd.paths.sync-sddm-screen-config = {
    wantedBy = [ "multi-user.target" ];
    pathConfig.PathModified = "/home/trenton/.config/kwinoutputconfig.json";
  };
}
