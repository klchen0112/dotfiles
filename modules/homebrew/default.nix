{ inputs, ... }:
{
  flake-file.inputs = {
    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-darwin.follows = "nix-darwin";
      };
    };
  };
  flake.modules.darwin.homebrew =
    {
      ...
    }:
    {
      imports = [
        inputs.brew-nix.darwinModules.default
      ];
      brew-nix.enable = true;
      homebrew = {
        # Declare Homebrew using Nix-Darwin
        enable = true;
        onActivation = {
          autoUpdate = true; # Auto update packages
          upgrade = true;
          cleanup = "zap"; # Uninstall not listed packages and casks
        };
        global.autoUpdate = true;
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
          "mas"
        ];

        casks = [
          "anki"
          "snipaste"
          "appcleaner"
          "microsoft-remote-desktop"
          "google-chrome"
          "logi-options+"
          # "firefox"
          # "zen"
          # "podman-desktop"
          "squirrel-app"
          "zotero"
          "omnidisksweeper"
          "licecap"
          # "raycast"
          # Keyboard
          "hhkb-studio"
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
          # "feishu"
          # "ghostty"
          "istat-menus"
        ];
      };
    };
  flake.modules.homeManager.homebrew = {
    nixpkgs.overlays = [
      inputs.brew-nix.overlays.default
    ];
  };
}
