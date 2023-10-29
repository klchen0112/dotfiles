{ inputs
, outputs
, lib
, config
, pkgs
, username
, ...
}: {
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