{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  isWork ? true,
  ...
}:
{
  imports = [
    inputs.brew-nix.darwinModules.default
  ];
  brew-nix.enable = true;
  environment.systemPackages =
    with inputs.brew-nix.packages.${pkgs.system};
    [
      # sf-symbols
      # squirrel
      anki
      snipaste
      # google-chrome

      appcleaner

      #baidunetdisk

      # keyboardcleantool


      omnidisksweeper

      # xnviewmp

      zotero
      # zerotier-one
      # TidGi
      # mathpix-snipping-tool
      # "logi-options-plus"
      # marginnote
      raycast
      # sol

    ]
    ++ lib.optionals isWork [
      # iterm2
    ]
    ++ lib.optionals (!isWork) [
      # syncthing
      # sunloginclient
      # adrive
      # steam
      # balenaetcher
      # todesk
      # marginnote
      # nutstore
      discord
      # openvpn-connect
      activitywatch
      # sfm
      plexamp
      # keyboard
      qmk-toolbox
      # openscad
      vial

      # vpn
      # tailscale

      telegram
    ];
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
       
        "Bitwarden" = 1352778147;
       
       
        # dingtalk = 1435447041;
        xcode = 497799835;
       
      }
      // (
        if isWork then
          { }
        else
          {
             "goodnotes-5" = 1444383602;
             qq = 451108668;
             wechat = 836500024;
             spark = 1176895641;
            # onedrive = 823766827;
            # tencent-meeting = 1484048379;
            "microsoft-word" = 462054704;
            "microsoft-powerpoint" = 462062816;
            "microsoft-excel" = 462058435;
          }
      );

    brews = [
      # "macism
      #"sleepwatcher"
      #"musl-cross"
      # "micromamba"
      "syncthing"
      
    ] ++ lib.optionals isWork [
      "podman"
      "podman-compose"
      "podman-tui"

    ];
    taps = [
      # "homebrew/cask"
      # "homebrew/services"
    ];
    casks =
      [
        "microsoft-remote-desktop"
        "google-chrome"
        "logi-options+"
        "firefox"
        "font-sf-pro"
        "font-sf-mono"
        "zen-browser"
        "podman-desktop"
        "squirrel"
      # mpv
      "iina"
      "skim"

      "licecap"
      # Keyboard
      # hhkbStudio
      # microsoft-remote-desktop
        # "syncthing"
      ]
      ++ lib.optionals (!isWork) [
        "steam"
        "adrive"
      ]
      ++ lib.optionals isWork [
        "iterm2"
        # "docker"
      ];
  };
}
