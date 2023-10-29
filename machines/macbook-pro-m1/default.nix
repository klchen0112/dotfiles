{ inputs
, outputs
, config
, pkgs
, username
, system
, ...
}: {

  imports = [
    ../base/fonts.nix
    ../../modules/nixpkgs/darwin.nix
    ./system.nix
    ../../modules/desktop/yabai
  ];

  users.users.${username} = {
    # macOS user
    home = "/Users/${username}";
    name = "${username}";
    shell = pkgs.fish; # Default shell
  };


  programs.fish.enable = true;

  environment = {
    shells = with pkgs; [ fish bash ]; # Default shell
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
      cachix
      # sketchybar
      fontconfig
      gnugrep # replacee macos's grep
      gnutar # replacee macos's tar
    ];
  };

  services.activate-system.enable = true;
  services.emacs = {
    enable = true;
    package =
      if pkgs.stdenv.hostPlatform.isDarwin then
        pkgs.emacs-plus
      else
        pkgs.emacs29;

  };




  # services.sketchybar-bottom = {
  #   enable = false;
  # };




  homebrew = {
    # Declare Homebrew using Nix-Darwin
    enable = true;
    onActivation = {
      autoUpdate = true; # Auto update packages
      upgrade = false;
      cleanup = "zap"; # Uninstall not listed packages and casks
    };
    masApps = {
      wechat = 836500024;
      qq = 451108668;
      dingtalk = 1435447041;
      #. tencent-meeting = 1484048379;
      "microsoft-word" = 462054704;
      "microsoft-powerpoint" = 462062816;
      "microsoft-excel" = 462058435;
      onedrive = 823766827;
      "goodnotes-5" = 1444383602;
      # xcode = 497799835;
    };

    taps = [
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/services"
      "laishulu/macism"
      # "FelixKratz/formulae"
    ];
    brews = [
      "macism"
      "mas"
    ];
    casks = [
      "squirrel"
      "microsoft-remote-desktop"
      "anki"
      # "sketchybar"
      # "sunloginclient"
      # "adrive"
      "snipaste"
      "google-chrome"
      "steam"
      "appcleaner"
      # "firefox"
      # "hammerspoon"
      # "authy"
      # "hiddenbar"
      # "telegram"
      # "baidunetdisk"
      # "iterm2"
      "balenaetcher"
      "keyboardcleantool"
      # "todesk"
      # "marginnote"
      "vial"
      #"dash"
      # "nutstore"
      "omnidisksweeper"
      # "discord"
      # "xnviewmp"
      # "openvpn-connect"
      # "zotero"
      "skim"
      # "via"
      #"miniconda"
      # "activitywatch"
      # "openscad"
      "qmk-toolbox"
      # "mathpix-snipping-tool"
      # "sing-box"
      "logi-options-plus"
      "sfm"
      #TODO remove
      "marginnote"
      "zotero"
      "logseq"
      "tencent-meeting"
      "telegram"
      "resilio-sync"
      "via"
      "zerotier-one"
    ];
  };





}

