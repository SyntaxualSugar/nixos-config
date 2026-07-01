{ config, pkgs, lib, inputs, ... }:

{
  # Hardware helpers
  hardware.enableAllFirmware = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.rtl-sdr.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
  General = {
    Enable = "Source,Sink,Media,Socket";
    FastConnectable = "true";
    Experimental = true;
    };
  };

  # SCX service (scheduler)
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
    extraArgs = [ "--autopower" ];
  };

  # Flatpak (ensure single source of truth for flatpak enablement)
  services.flatpak.enable = true;

  # X11 keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Input device daemon
  services.ratbagd.enable = true;

  # Printing
  services.printing.enable = true;

  # Audio stack
  services.pulseaudio.enable = false;
  security.rtkit.enable = true; #for realtime audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Syncthing configuration
  services.syncthing = {
    enable = true;
    user = "trenton";
    dataDir = "/Media";
    settings = {
      options = {
        urAccepted = -1;
        relaysEnabled = true;
      };
      folders = {
        "Music" = {
          path = "/Media/Music";
          devices = [ "neptune" "OrangePi5" ];
        };
        "Movies" = {
          path = "/Media/Movies";
          devices = [ "OrangePi5" ];
        };
        "TV" = {
          path = "/Media/TV";
          devices = [ "OrangePi5" ];
        };
        "Configs" = {
          path = "/Media/Configs";
          devices = [ "OrangePi5" ];
        };
      };
      devices = {
        "neptune" = { id = "S4CNLVA-LIAGHT6-MI6O2VJ-E7EUQDV-NSC5Q6A-B5PHAIY-3GND2OI-TZIQLAS"; };
        "OrangePi5" = { id = "6UC4JCM-MFJEZMT-HM5K2FF-PYFG4DF-YAMCLHQ-AQGQ7XN-GQVRAHD-QDK6EAS"; };
      };
    };
  };
}
