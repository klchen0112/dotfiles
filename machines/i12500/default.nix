#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#
{ config
, pkgs
, username
, system
, inputs
, ...
}: {


  users.users.${username} = {
    # macOS user
    isNormalUser = true;
    home = "/Users/${username}";
    extraGroups = [ "wheel" ];
    shell = pkgs.fish; # Default shell
  };

  security.sudo.wheelNeedsPassword = false; # User does not need to give password when using sudo.

  time.timeZone = "Asia/Shanghai"; # Time zone and internationalisation

  i18n = {
    defaultLocale = "en_US.UTF-8";
    # extraLocaleSettings = {
    #   # Extra locale settings that need to be overwritten
    #   LC_TIME = "nl_BE.UTF-8";
    #   LC_MONETARY = "nl_BE.UTF-8";
    # };

  };


  fonts = {
    # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      # jetbrains-mono
      # cascadia-code
      # comic-mono
      # fira-code
      ibm-plex
      roboto-mono
      twemoji-color-font
      # mononoki
      symbola
      # noto-fonts
      # noto-fonts-extra
      # noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      # noto-fonts-lgc-plus
      lxgw-wenkai
      liberation_ttf
      overpass
      freefont_ttf
      # source-code-pro
      # source-sans-pro
      # source-serif-pro
      # sarasa-gothic
      iosevka
      cm_unicode
      hanazono
      lmodern
      # lmmath
    ];
  };

  environment = {
    shells = with pkgs; [ bashInteractive fish ]; # Default shell
    variables = {
      # System variables
      # EDITOR = "nvim";
      # VISUAL = "nvim";
      TERMINAL = "wezterm";
    };
    systemPackages = with pkgs; [
      # Installed Nix packages
      # Terminal
      # bash
      fish
      # zsh
      fontconfig
      home-manager
      coreutils
      cachix
      jq # for yabai json parser
      # sketchybar
      gzip
      nixpkgs-fmt
    ];
  };
  nixpkgs.config.allowUnfree = true; # Allow proprietary software.

  services = {
    activate-system.enable = true;
    # ariang.enable = true;
    openssh = {
      enable = true;
      allowSFTP = true;
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      ''; # Temporary extra config so ssh will work in guacamole

    };

    nix-daemon.enable = true; # Auto upgrade daemon
    emacs = {
      enable = false;
      package = pkgs.emacs29;
      # https://github.com/nix-community/nix-doom-emacs/blob/master/docs/reference.md#emacs-daemon
      # package = inputs.nix-doom-emacs.packages.${system}.doom-emacs.override {
      #  doomPrivateDir = ../../doom;
      #  emacsPackage = pkgs.emacs-unstable;
      # };
    };


    nix = {
      package = pkgs.nix;
      gc = {
        # Garbage collection
        automatic = true;
        interval.Day = 7;
        options = "--delete-older-than 7d";
      };
      extraOptions = ''
        auto-optimise-store = true
        experimental-features = nix-command flakes
      '';

      settings = {
        auto-optimise-store = true;

      };
    };

    system = {
      autoUpgrade = {
        # Allow auto update (not useful in flakes)
        enable = true;
        channel = "https://nixos.org/channels/nixos-unstable";
      };

    };
  }
