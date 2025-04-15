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

      ## Coding
      dash

      omnidisksweeper

      # xnviewmp

      zotero
      skim
      # zerotier-one
      # TidGi
      # mathpix-snipping-tool
      # "logi-options-plus"
      # marginnote
      raycast
      # sol

      # mpv
      iina

      licecap
      # Keyboard
      # hhkbStudio
      # microsoft-remote-desktop
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
      "podman"
      "podman-compose"
      "podman-tui"
      "syncthing"
      
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
        "iterm2"
        # "syncthing"
      ]
      ++ lib.optionals (!isWork) [
        "steam"
        "adrive"
      ]
      ++ lib.optionals isWork [
        # "docker"
      ];
  };
}
