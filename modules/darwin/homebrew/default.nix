{
  homebrew = {
    # Declare Homebrew using Nix-Darwin
    enable = true;
    onActivation = {
      autoUpdate = true; # Auto update packages
      upgrade = true;
      cleanup = "zap"; # Uninstall not listed packages and casks
    };
    global.autoUpdate = false;
    masApps = {

      # "Bitwarden" = 1352778147;

      # dingtalk = 1435447041;
      # xcode = 497799835;

      "goodnotes-5" = 1444383602;
      qq = 451108668;
      wechat = 836500024;
      # spark = 1176895641;
      # onedrive = 823766827;
      # tencent-meeting = 1484048379;
      # "microsoft-word" = 462054704;
      # "microsoft-powerpoint" = 462062816;
      # "microsoft-excel" = 462058435;

    };

    brews = [
      # "macism
      #"sleepwatcher"
    ];
    taps = [
      # "homebrew/cask"
      # "homebrew/services"
    ];
    casks = [
      "anki"
      "snipaste"
      "appcleaner"
      "microsoft-remote-desktop"
      "google-chrome"
      "logi-options+"
      # "firefox"
      "zen"
      "podman-desktop"
      "squirrel"
      # mpv
      "iina"
      "skim"
      "zotero"
      "omnidisksweeper"
      "licecap"
      "raycast"
      # Keyboard
      # hhkbStudio
      # microsoft-remote-desktop
      # "syncthing"
      "steam"
      "adrive"
      "discord"
      "activitywatch"
      "vial"
      "qmk-toolbox"
      "plexamp"
      "telegram"
      "iterm2"
      # "docker"
    ];
  };
}
