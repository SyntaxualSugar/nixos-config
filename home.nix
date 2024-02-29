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
  home.packages = with pkgs; [
    # cli
    gallery-dl
    gotop

    # desktop
    gparted
    libreoffice-qt
    obsidian
    ollama
    openscad
    pavucontrol
    super-slicer-latest
    syncthingtray
    vivaldi

    # dev tools
    jetbrains.goland
    jetbrains.pycharm-community
    rustup

    # gaming
    heroic
    gamemode
    prismlauncher

    # media
    czkawka
    haruna
    jellyfin-media-player
    mpv

    # plasma
    cryfs # for plasma vault
    gocryptfs # for plasma vault
    kate
    libsForQt5.kdeconnect-kde
    libsForQt5.kdegraphics-thumbnailers
    libsForQt5.dolphin-plugins
    plasma-vault

    # social
    discord
    telegram-desktop
    thunderbird
    zoom-us
  ];

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

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
      update-home = "home-manager switch";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "python" "man" "docker" "docker-compose" "rust" "golang" ];
      theme = "agnoster";
    };
  };

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userEmail = "tcfox54@gmail.com";
    userName = "Trenton Fox";

    extraConfig = {
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