{ config, pkgs, ... }: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "trenton";
  home.homeDirectory = "/home/trenton";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" # For obsidian
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs.stable; [
    # cli
    gallery-dl
    gotop
    yt-dlp
    jq

    # nix dev
    nixpkgs-fmt
    nixpkgs-hammering
    nixpkgs-review

    # desktop
    alpaca
    betaflight-configurator
    btrfs-assistant
    btrfs-progs
    canon-cups-ufr2 #printer driver
    chirp
    czkawka
    darktable
    f3d #stl thumbnailer
    freecad
    gimp
    go
    headphones-toolbox # for ploopy headphone amp
    libreoffice-qt
    mullvad-browser
    networkmanager-openvpn
    nix-init
    obsidian
    openscad
    orca-slicer
    pavucontrol
    piper # for logitech 502
    popsicle # writes ISOs
    sdrpp # for software defined radio
    super-slicer-latest
    solaar
    syncthingtray
    thunderbird
    wireguard-tools
    winbox
    vivaldi

    # gaming
    heroic
    gamemode
    prismlauncher
    sidequest

    # media
    czkawka
    haruna
    jellyfin-media-player
    mpv
    strawberry

    # plasma
    cryfs # for plasma vault
    gocryptfs # for plasma vault
    kdePackages.kate
    kdePackages.kdeconnect-kde
    kdePackages.kdegraphics-thumbnailers
    kdePackages.dolphin-plugins
    kdePackages.plasma-vault

    # social
    discord
    telegram-desktop
    zoom-us

    # fish
    bat #Needed for fzf plugin
    fd #Needed for fzf plugin
    fzf #Needed for fzf plugin
    fishPlugins.autopair
    fishPlugins.colored-man-pages
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.sponge
    fishPlugins.tide
  ] ++ (with pkgs; [

  ]);

  # Environment Variables
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # Program enablement

  programs = {
    firefox.enable = true;
    htop.enable = true;
    java.enable = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
        ll = "ls -la";
        rebuild = "sudo nixos-rebuild switch --flake /home/trenton/nix-config#default";
        update = "sudo nix flake update /home/trenton/nix-config";
    };
  };

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    settings = {
      user = {
        email = "tcfox54@gmail.com";
        name = "Trenton Fox";
      };
      core = { whitespace = "trailing-space,space-before-tab"; };
      color = { ui = "auto"; };
      merge = { ff = "only"; };
      rerere = { enabled = "true"; };
      rebase = { autoSquash = "true"; };
      github = { user = "SyntaxualSugar"; };
    };

    ignores = [
      "*~"
      "*.swp"
      ".ccls-cache"
      "*.pdf"
      "compile_commands.json"
      "shell.nix"
    ];
  };

  xdg.desktopEntries = {
    firefox = {
      name = "Firefox";
      genericName = "Web Browser";
      exec = "MOZ_ENABLE_WAYLAND=0 firefox %U";
      terminal = false;
      categories = [ "Application" "Network" "WebBrowser" ];
      mimeType = [ "text/html" "text/xml" ];
    };
  };

  # Services


  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
}
