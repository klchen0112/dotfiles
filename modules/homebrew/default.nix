{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  isWork ? true,
  ...
}: {
  homebrew = {
    # Declare Homebrew using Nix-Darwin
    enable = true;
    onActivation = {
      autoUpdate = true; # Auto update packages
      upgrade = true;
      cleanup = "zap"; # Uninstall not listed packages and casks
    };
    global.autoUpdate = false;
    masApps =
      {
        "goodnotes-5" = 1444383602;
        "Bitwarden" = 1352778147;
        wechat = 836500024;
        qq = 451108668;
        dingtalk = 1435447041;
        xcode = 497799835;
        spark = 1176895641;
      }
      // (
        if isWork
        then {}
        else {
          onedrive = 823766827;
          tencent-meeting = 1484048379;
          "microsoft-word" = 462054704;
          "microsoft-powerpoint" = 462062816;
          "microsoft-excel" = 462058435;
        }
      );

    taps = builtins.attrNames config.nix-homebrew.taps;
    brews = [
      # "macism"
      "mas"
      "sleepwatcher"
    ];
    caskArgs = {no_quarantine = true;};
    casks =
      [
        "sf-symbols"
        "squirrel"
        "anki"
        "snipaste"
        "google-chrome"

        "appcleaner"

        "baidunetdisk"
        "iterm2"

        "keyboardcleantool"
        # keyboard

        "vial"

        # Coding
        "dash"

        "omnidisksweeper"

        "xnviewmp"

        "zotero"
        "skim"
        "zerotier-one"

        # "TidGi"
        # "mathpix-snipping-tool"
        "logi-options-plus"
        "marginnote"
        "raycast"
        "plexamp"
        "syncthing"
        # "mpv"
        "iina"
        "licecap"
      ]
      ++ lib.optionals (!isWork) [
        "microsoft-remote-desktop"
        "sunloginclient"
        "adrive"
        "steam"
        "telegram"
        "balenaetcher"
        "todesk"
        "tencent-meeting"
        "marginnote"
        "nutstore"
        "discord"
        "openvpn-connect"
        "activitywatch"
        "sfm"

        # keyboard
        "qmk-toolbox"
        "openscad"
      ];
  };
}
