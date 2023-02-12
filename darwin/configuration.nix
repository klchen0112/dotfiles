#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#

{ config, pkgs, user, ... }:

{
  imports =
  (import ../modules/editors) ++
  (import ../modules/shell);

  users.users."${user}" = {
    # macOS user
    home = "/Users/${user}";
    shell = pkgs.fish; # Default shell
  };

  # networking = {
  #   computerName = "MacBook"; # Host name
  #   hostName = "MacBook";
  # };

  fonts = {
    # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
fira-code
ibm-plex
roboto-mono
twemoji-color-font
mononoki
symbola
noto-fonts
noto-fonts-extra
noto-fonts-emoji
noto-fonts-cjk-sans
noto-fonts-cjk-serif
# noto-fonts-lgc-plus
lxgw-wenkai
liberation_ttf
overpass
freefont_ttf
source-code-pro
source-sans-pro
source-serif-pro
sarasa-gothic
iosevka
cm_unicode
hanazono
lmodern
# lmmath
# nerdfonts
material-design-icons
weather-icons
emacs-all-the-icons-fonts
];

  };

  environment = {
    shells = with pkgs; [ zsh ]; # Default shell
    variables = {
      # System variables
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [
      # Installed Nix packages
      # Terminal
      ansible
      git
      ranger
      bat


      # Doom Emacs
      emacs
      fd
      ripgrep
      pandoc
      tree-sitter
    ];
  };

  programs = {
    # Shell needs to be enabled
    zsh.enable = true;
    fish.enable = true;
  };

  services = {
    nix-daemon.enable = true; # Auto upgrade daemon
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

    taps = ["homebrew/cask"
  "homebrew/cask-fonts"
  "homebrew/core"
  "homebrew/services"
];
    brews = [
      "mas"
  "pngpaste" # for emacs download clipboard


    ];
    casks = [
"adrive"
"font-sf-pro"
"snipaste"
"anki"
"google-chrome"
"steam"
"appcleaner"
"hammerspoon"
"sublime-text"
"authy"
"hiddenbar"
"telegram"
"baidunetdisk"
"iterm2"
"balenaetcher"
"keyboardcleantool"
"todesk"
"calibre"
"marginnote"
"vial"
"dash"
"nutstore"
"visual-studio-code"
"omnidisksweeper"
"vlc"
"discord"
"plex"
"plexamp"
"font-sf-arabic"
"xnviewmp"
"font-sf-compact"
"raycast"
"zerotier-one"
"font-sf-mono"
"sioyek"
"zotero"
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


    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/fish''; # Since it's not possible to declare default shell, run this command after build
    stateVersion = 4;
  };
}
