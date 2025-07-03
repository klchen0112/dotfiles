{
  flake,
  config,
  ...
}:
{
  imports = [
    flake.inputs.nix-homebrew.darwinModules.nix-homebrew
  ];
  nix-homebrew = {
    # Install Homebrew under the default prefix
    enable = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = true;

    # User owning the Homebrew prefix
    user = builtins.head config.myusers;

    # Optional: Declarative tap management
    taps = {
      "homebrew/homebrew-core" = flake.inputs.homebrew-core;
      "homebrew/homebrew-cask" = flake.inputs.homebrew-cask;
    };

    # Optional: Enable fully-declarative tap management
    #
    # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
    mutableTaps = false;
    # Automatically migrate existing Homebrew installations
    autoMigrate = true;
  };
  homebrew = {
    # Declare Homebrew using Nix-Darwin
    enable = true;
    onActivation = {
      autoUpdate = false; # Auto update packages
      upgrade = false;
      cleanup = "zap"; # Uninstall not listed packages and casks
    };
    global.autoUpdate = false;
    masApps = {

      # "Bitwarden" = 1352778147;

      # dingtalk = 1435447041;
      # xcode = 497799835;

      # "goodnotes-5" = 1444383602;
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
      "squirrel-app"
      "iina"
      "skim"
      "zotero"
      "omnidisksweeper"
      "licecap"
      "raycast"
      # Keyboard
      # hhkbStudio
      # microsoft-remote-desktop
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
      "feishu"
      "ghostty"
    ];
  };
}
