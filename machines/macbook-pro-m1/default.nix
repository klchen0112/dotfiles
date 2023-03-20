#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#
{
  config,
  pkgs,
  user,
  ...
}: {
  users.users."${user}" = {
    # macOS user
    home = "/Users/${user}";
    shell = pkgs.fish; # Default shell
  };

  fonts = {
    # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      jetbrains-mono
      cascadia-code
      comic-mono
      fira-code
      ibm-plex
      roboto-mono
      twemoji-color-font
      # mononoki
      symbola
      # noto-fonts
      # noto-fonts-extra
      noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      # noto-fonts-lgc-plus
      lxgw-wenkai
      liberation_ttf
      overpass
      freefont_ttf
      # source-code-pro
      # source-sans-pro
      # source-serif-pro
      # sarasa-gothic
      iosevka
      cm_unicode
      hanazono
      lmodern
      # lmmath
    ];
  };

  environment = {
    shells = with pkgs; [bashInteractive fish zsh]; # Default shell
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
      home-manager
      coreutils
      cachix
    ];
  };

  services = {
    activate-system.enable = true;
    nix-daemon.enable = true; # Auto upgrade daemon
    emacs = {
      enable = true;
      package = pkgs.emacsGit;
    };
    yabai = {
      enable = true;
      config = {
        external_bar = "all:0:26";
      };
      extraConfig = ''
        yabai -m config debug_output                  on
        yabai -m config mouse_follows_focus           off
        yabai -m config focus_follows_mouse           off
        yabai -m config window_placement              second_child
        yabai -m config window_topmost                off
        yabai -m config window_opacity                on
        yabai -m config window_opacity_duration       0.0
        yabai -m config window_shadow                 on
        yabai -m config window_border                 off
        yabai -m config active_window_opacity         1.0
        yabai -m config normal_window_opacity         0.85
        yabai -m config split_ratio                   0.62
        yabai -m config auto_balance                  off
        yabai -m config layout                        bsp
        yabai -m config top_padding                   0
        yabai -m config bottom_padding                0
        yabai -m config left_padding                  0
        yabai -m config right_padding                 0
        yabai -m config window_gap                    0
        yabai -m rule --add app="emacs" title!="^$"   manage="on"
        yabai -m rule --add app="Dash"                manage="off"
        yabai -m rule --add app="System Preferences"  manage="off"
        yabai -m rule --add app="Plexamp"             manage="off"
      '';
    };
    skhd = {
      enable = true;
      skhdConfig = let
        modMask = "cmd";
        moveMask = "ctrl + cmd";
        # myTerminal = "emacsclient -a '' -nc --eval '(peel/vterm)'";
        myEditor = "emacsclient -a '' -nc";
        myPlayer = "open /Applications/Plexamp.app";
        noop = "/dev/null";
        prefix = "yabai -m";
        fstOrSnd = {
          fst,
          snd,
        }: domain: "${prefix} ${domain} --focus ${fst} || ${prefix} ${domain} --focus ${snd}";
        nextOrFirst = fstOrSnd {
          fst = "next";
          snd = "first";
        };
        prevOrLast = fstOrSnd {
          fst = "prev";
          snd = "last";
        };
        keycodes = import ./keycodes.nix;
      in ''
        # windows ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
        # select
        ${modMask} - j                            : ${prefix} window --focus next || ${prefix} window --focus "$((${prefix} query --spaces --display next || ${prefix} query --spaces --display first) |${pkgs.jq}/bin/jq -re '.[] | select(.visible == 1)."first-window"')" || ${prefix} display --focus next || ${prefix} display --focus first
        ${modMask} - k                            : ${prefix} window --focus prev || ${prefix} window --focus "$((yabai -m query --spaces --display prev || ${prefix} query --spaces --display last) | ${pkgs.jq}/bin/jq -re '.[] | select(.visible == 1)."last-window"')" || ${prefix} display --focus prev || ${prefix} display --focus last
        # close
        ${modMask} - ${keycodes.Delete}           : ${prefix} window --close && yabai -m window --focus prev
        # fullscreen
        ${modMask} - h                            : ${prefix} window --toggle zoom-fullscreen
        # rotate
        ${modMask} - r                            : ${prefix} window --focus smallest && yabai -m window --warp largest && yabai -m window --focus largest
        # increase region
        ${modMask} - ${keycodes.LeftBracket}      : ${prefix} window --resize left:-20:0
        ${modMask} - ${keycodes.RightBracket}     : ${prefix} window --resize right:-20:0
        # spaces ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
        # switch
        ${modMask} + alt - j                      : ${prevOrLast "space"}
        ${modMask} + alt - k                      : ${nextOrFirst "space"}
        # send window
        ${modMask} + ${moveMask} - j              : ${prefix} window --space prev
        ${modMask} + ${moveMask} - k              : ${prefix} window --space next
        # display  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
        # focus
        ${modMask} - left                         : ${prevOrLast "display"}
        ${modMask} - right                        : ${nextOrFirst "display"}
        # send window
        ${moveMask} - right                       : ${prefix} window --display prev
        ${moveMask} - left                        : ${prefix} window --display next
        # apps  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
        ${modMask} + shift - return               : ${myEditor}
        ${modMask} - p                            : ${myPlayer}
        # reset  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
        ${modMask} - q                            : pkill yabai; pkill skhd; osascript -e 'display notification "wm restarted"'
        # blacklist
        .blacklist [
        \"terminal\"
        \"qutebrowser\"
        \"kitty\"
        \"google chrome\"
        ]'';
    };
    spacebar = {
      enable = true;
      package = pkgs.spacebar;
      config = {
        position = "top";
        display = "main";
        height = 26;
        title = "on";
        spaces = "on";
        clock = "on";
        power = "on";
        padding_left = 20;
        padding_right = 20;
        spacing_left = 25;
        spacing_right = 15;
        text_font = ''"Menlo:Regular:12.0"'';
        icon_font = ''"Font Awesome 5 Free:Solid:12.0"'';
        background_color = "0xff202020";
        foreground_color = "0xffa8a8a8";
        power_icon_color = "0xffcd950c";
        battery_icon_color = "0xffd75f5f";
        dnd_icon_color = "0xffa8a8a8";
        clock_icon_color = "0xffa8a8a8";
        power_icon_strip = " ";
        space_icon = "•";
        space_icon_strip = "1 2 3 4 5 6 7 8 9 10";
        spaces_for_all_displays = "on";
        display_separator = "on";
        display_separator_icon = "";
        space_icon_color = "0xff458588";
        space_icon_color_secondary = "0xff78c4d4";
        space_icon_color_tertiary = "0xfffff9b0";
        clock_icon = "";
        dnd_icon = "";
        clock_format = ''"%d/%m/%y %R"'';
        right_shell = "on";
        right_shell_icon = "";
        right_shell_command = "whoami";
      };
    };
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

    taps = [
      "homebrew/cask"
      "homebrew/core"
      "homebrew/services"
      "laishulu/macism"
    ];
    brews = [
      "mas"
      "pngpaste" # for emacs download clipboard
      "macism"
    ];
    casks = [
      "sunloginclient"
      # "adrive"
      "snipaste"
      "anki"
      "google-chrome"
      "steam"
      "appcleaner"
      # "hammerspoon"
      "sublime-text"
      # "authy"
      "hiddenbar"
      "telegram"
      "baidunetdisk"
      # "iterm2"
      "balenaetcher"
      "keyboardcleantool"
      "todesk"
      "calibre"
      "marginnote"
      "vial"
      "dash"
      "nutstore"
      "omnidisksweeper"
      "vlc"
      "discord"
      "plexamp"
      "xnviewmp"
      "raycast"
      "openvpn-connect"
      "zotero"
      # "arc"
      # "via"
      "logseq"
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

    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
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
        appswitcher-all-displays = true;
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

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    # activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/fish''; # Since it's not possible to declare default shell, run this command after build
    stateVersion = 4;
  };
}
