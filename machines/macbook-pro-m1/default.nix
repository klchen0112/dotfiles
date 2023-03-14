#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#
{
  config,
  pkgs,
  user,
  ...
}: {
  users.users."${user}" = {
    # macOS user
    home = "/Users/${user}";
    shell = pkgs.fish; # Default shell
  };

  fonts = {
    # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      jetbrains-mono
      cascadia-code
      comic-mono
      fira-code
      ibm-plex
      roboto-mono
      twemoji-color-font
      # mononoki
      symbola
      # noto-fonts
      # noto-fonts-extra
      noto-fonts-emoji
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
    shells = with pkgs; [bashInteractive fish zsh]; # Default shell
    # variables = {
    #   # System variables
    #   EDITOR = "nvim";
    #   VISUAL = "nvim";
    # };
    systemPackages = with pkgs; [
      # Installed Nix packages
      # Terminal
      # bash
      fish
      # zsh
      home-manager
      coreutils
    ];
  };

  services = {
    nix-daemon.enable = true; # Auto upgrade daemon
    emacs = {
      enable = true;
      package = pkgs.emacsGit;
    };
    #yabai = {
    #  enable = true;
    #};
  };

  homebrew = {
    # Declare Homebrew using Nix-Darwin
    enable = true;
    onActivation = {
      autoUpdate = false; # Auto update packages
      upgrade = false;
      cleanup = "zap"; # Uninstall not listed packages and casks
    };
    masApps = {
      wechat = 836500024;
      qq = 451108668;
      dingtalk = 1435447041;
      tencent-meeting = 1484048379;
      emby = 992180193;
      "microsoft-word" = 462054704;
      "microsoft-powerpoint" = 462062816;
      "microsoft-excel" = 462058435;
      onedrive = 823766827;
      "goodnotes-5" = 1444383602;
    };

    taps = [
      "homebrew/cask"
      "homebrew/core"
      "homebrew/services"
      "laishulu/macism"
    ];
    brews = [
      "mas"
      "pngpaste" # for emacs download clipboard
      "macism"
    ];
    casks = [
      # "adrive"
      "snipaste"
      "anki"
      "google-chrome"
      "steam"
      "appcleaner"
      # "hammerspoon"
      "sublime-text"
      # "authy"
      "hiddenbar"
      "telegram"
      "baidunetdisk"
      # "iterm2"
      "balenaetcher"
      "keyboardcleantool"
      "todesk"
      "calibre"
      "marginnote"
      "vial"
      "dash"
      "nutstore"
      "omnidisksweeper"
      "vlc"
      "discord"
      "plexamp"
      "xnviewmp"
      "raycast"
      "openvpn-connect"
      "zotero"
      "arc"
      # "via"
      "logseq"
    ];
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
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  security.pam.enableSudoTouchIdAuth = true;
  system = {
    defaults = {
      NSGlobalDomain = {
        # Global macOS system settings
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
      dock = {
        # Dock settings
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        tilesize = 40;
        appswitcher-all-displays = true;
      };
      finder = {
        # Finder settings
        QuitMenuItem = false; # I believe this probably will need to be true if using spacebar
      };
      trackpad = {
        # Trackpad settings
        Clicking = true;
        TrackpadRightClick = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    # activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/fish''; # Since it's not possible to declare default shell, run this command after build
    stateVersion = 4;
  };
}
