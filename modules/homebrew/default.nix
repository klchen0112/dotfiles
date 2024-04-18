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
        # xcode = 497799835;
      }
      // (
        if isWork
        then {}
        else {
          wechat = 836500024;
          qq = 451108668;
          onedrive = 823766827;
          dingtalk = 1435447041;
          #. tencent-meeting = 1484048379;
          "microsoft-word" = 462054704;
          "microsoft-powerpoint" = 462062816;
          "microsoft-excel" = 462058435;
        }
      );

    taps = builtins.attrNames config.nix-homebrew.taps;
    brews = [
      # "macism"
      "mas"
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

        "vial"
        "dash"

        "omnidisksweeper"

        "xnviewmp"
        "zotero"
        "skim"

        # "TidGi"
        # "mathpix-snipping-tool"
        "logi-options-plus"
        "sfm"
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

        # keyboard
        "via"
        "vial"
        "qmk-toolbox"
        "openscad"
        "zerotier-one"
      ];
  };
}
