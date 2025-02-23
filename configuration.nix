# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }: {
  imports =
    [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings = {
    substituters = ["https://nix-gaming.cachix.org" "https://ai.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="];
  };

  fileSystems."/Media" =
    {
      device = "/dev/disk/by-uuid/c72e4dfc-37f7-4907-a5f3-98f0f8ad3616";
      fsType = "btrfs";
      options = ["compress=zstd:3"];
    };
  services.btrfs.autoScrub.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.configurationLimit = 20;


  # Setting up a udev rule for ploopy headphone dac
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="fedd", MODE="666"
  '';

  # Networking
  networking.hostName = "nixos"; # Define your hostname.
  networking.firewall = { 
    enable = true;
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; } # KDE Connect
    ];  
  };  
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Enable hardware firmware
  hardware.enableAllFirmware = true;

  # Enable Proprietary NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable sdr
  hardware.rtl-sdr.enable = true;

  # Enable Preload
  services.preload.enable = true;

  # Enable PDNSD
  services.pdnsd.enable = true;

  # Enable ratbagd for logitech 502
  services.ratbagd.enable = true;

  # Enable KDE Plasma
  services.displayManager.sddm.enable = lib.mkDefault true;
  services.displayManager.sddm.wayland.enable = lib.mkDefault true;
  services.desktopManager.plasma6.enable = lib.mkDefault true;

  # Enable Flatpak - This has to be done in specialisation so that xdg portals are auto loaded for the respective DE
  services.flatpak.enable = true;

  specialisation.gnome.configuration = {
    # Enable Gnome
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.displayManager.gdm.wayland = true;
    services.xserver.desktopManager.gnome.enable = true;

    services.displayManager.sddm.enable = false;
    services.displayManager.sddm.wayland.enable = false;
    services.desktopManager.plasma6.enable = false;

    # Enable Flatpak - This has to be done in specialisation so that xdg portals are auto loaded for the respective DE
    services.flatpak.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Force wayland on electron apps
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.trenton = {
    isNormalUser = true;
    description = "trenton";
    extraGroups = [ "networkmanager" "wheel" "docker" "plugdev" "audio" ]; # plugdev is needed for sdr
  };

  users.defaultUserShell = pkgs.fish;
  programs.fish = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    users = {
      "trenton" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  virtualisation.docker.enable = true;
  programs.partition-manager.enable = true;
  programs.ssh.startAgent = true;
  programs.java.enable = true;

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    package = pkgs.steam.override { withJava = true; };
     extraCompatPackages = [
       pkgs.proton-ge-bin
     ];
  };

  # Enable Gamemode
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  # Enable Sunshine for streaming to Quest/Moonlight
  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
  };

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
