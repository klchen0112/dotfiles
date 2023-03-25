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
  users.users.chenkailong = {
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
      extraConfig = let
        gaps = {
          top = "4";
          bottom = "24";
          left = "4";
          right = "4";
          inner = "4";
        };
        color = {
          focused = "0xE0808080";
          normal = "0x00010101";
          preselect = "0xE02d74da";
        };
      in ''
        #!/usr/bin/env bash

        # Uncomment to refresh ubersicht widget on workspace change
        # Make sure to replace WIDGET NAME for the name of the ubersicht widget
        #ubersicht_spaces_refresh_command="osascript -e 'tell application id \"tracesOf.Uebersicht\" to refresh widget id \"WIDGET NAME\"'"

        # ===== Loading Scripting Additions ============

        # See: https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)#macos-big-sur---automatically-load-scripting-addition-on-startup
        sudo yabai --load-sa
        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        # ===== Tiling setting =========================
        yabai -m config layout                      bsp

        yabai -m config top_padding                 ${gaps.top}
        yabai -m config bottom_padding              ${gaps.bottom}
        yabai -m config left_padding                ${gaps.left}
        yabai -m config right_padding               ${gaps.right}
        yabai -m config window_gap                  ${gaps.inner}

        yabai -m config mouse_follows_focus         off
        yabai -m config focus_follows_mouse         off

        yabai -m config window_topmost              off
        yabai -m config window_opacity              off
        yabai -m config window_shadow               float

        yabai -m config window_border               on
        yabai -m config window_border_width         2
        yabai -m config active_window_border_color  ${color.focused}
        yabai -m config normal_window_border_color  ${color.normal}
        yabai -m config insert_feedback_color       ${color.preselect}

        yabai -m config active_window_opacity       1.0
        yabai -m config normal_window_opacity       0.90
        yabai -m config split_ratio                 0.50

        yabai -m config auto_balance                off

        yabai -m config mouse_modifier              fn
        yabai -m config mouse_action1               move
        yabai -m config mouse_action2               resize
        # ===== Rules ==================================
        yabai -m rule --add label="Finder" app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
        yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
        yabai -m rule --add label="macfeh" app="^macfeh$" manage=off
        yabai -m rule --add label="System Preferences" app="^System Preferences$" title=".*" manage=off
        yabai -m rule --add label="App Store" app="^App Store$" manage=off
        yabai -m rule --add label="Activity Monitor" app="^Activity Monitor$" manage=off
        yabai -m rule --add label="KeePassXC" app="^KeePassXC$" manage=off
        yabai -m rule --add label="Calculator" app="^Calculator$" manage=off
        yabai -m rule --add label="Dictionary" app="^Dictionary$" manage=off
        yabai -m rule --add label="mpv" app="^mpv$" manage=off
        yabai -m rule --add label="Software Update" title="Software Update" manage=off
        yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
        yabai -m rule --add app="Dash"                manage="off"
        yabai -m rule --add app="Plexamp"             manage="off"
        # ===== Signals ================================

      '';
    };
    skhd = {
      enable = true;
      skhdConfig = ''
        # opens WezTerm
        alt - return : open \$\{HOME\}/Applications/Home Manager Apps/WezTerm.app


        # Navigation
        alt - h : yabai -m window --focus west
        alt - j : yabai -m window --focus south
        alt - k : yabai -m window --focus north
        alt - l : yabai -m window --focus east

        # Moving windows
        shift + alt - h : yabai -m window --warp west
        shift + alt - j : yabai -m window --warp south
        shift + alt - k : yabai -m window --warp north
        shift + alt - l : yabai -m window --warp east

        # Move focus container to workspace
        shift + alt - m : yabai -m window --space last; yabai -m space --focus last
        shift + alt - p : yabai -m window --space prev; yabai -m space --focus prev
        shift + alt - n : yabai -m window --space next; yabai -m space --focus next
        shift + alt - 1 : yabai -m window --space 1; yabai -m space --focus 1
        shift + alt - 2 : yabai -m window --space 2; yabai -m space --focus 2
        shift + alt - 3 : yabai -m window --space 3; yabai -m space --focus 3
        shift + alt - 4 : yabai -m window --space 4; yabai -m space --focus 4

        # Move focus container to monitor
        lctrl + alt - m : yabai -m window --display last; yabai -m display --focus last
        lctrl + alt - p : yabai -m window --display prev; yabai -m display --focus prev
        lctrl + alt - n : yabai -m window --display next; yabai -m display --focus next
        lctrl + alt - 1 : yabai -m window --display 1; yabai -m display --focus 1
        lctrl + alt - 2 : yabai -m window --display 2; yabai -m display --focus 2
        lctrl + alt - 3 : yabai -m window --display 3; yabai -m display --focus 3
        lctrl + alt - 4 : yabai -m window --display 4; yabai -m display --focus 4

        # Resize windows
        lctrl + alt - h : yabai -m window --resize left:-50:0; \
                          yabai -m window --resize right:-50:0
        lctrl + alt - j : yabai -m window --resize bottom:0:50; \
                          yabai -m window --resize top:0:50
        lctrl + alt - k : yabai -m window --resize top:0:-50; \
                          yabai -m window --resize bottom:0:-50
        lctrl + alt - l : yabai -m window --resize right:50:0; \
                          yabai -m window --resize left:50:0

        # Equalize size of windows
        lctrl + alt - e : yabai -m space --balance

        # Enable / Disable gaps in current workspace
        lctrl + alt - g : yabai -m space --toggle padding; yabai -m space --toggle gap

        # Rotate windows clockwise and anticlockwise
        alt - r         : yabai -m space --rotate 270
        shift + alt - r : yabai -m space --rotate 90

        # Rotate on X and Y Axis
        shift + alt - x : yabai -m space --mirror x-axis
        shift + alt - y : yabai -m space --mirror y-axis

        # Set insertion point for focused container
        shift + lctrl + alt - h : yabai -m window --insert west
        shift + lctrl + alt - j : yabai -m window --insert south
        shift + lctrl + alt - k : yabai -m window --insert north
        shift + lctrl + alt - l : yabai -m window --insert east

        # Float / Unfloat window
        shift + alt - space : \
            yabai -m window --toggle float; \
            yabai -m window --toggle border

        # Restart Yabai and Skhd
        shift + lctrl + alt - r : pkill yabai; pkill skhd; osascript -e 'display notification "wm restarted"'

        # Make window native fullscreen
        alt - f         : yabai -m window --toggle zoom-fullscreen
        shift + alt - f : yabai -m window --toggle native-fullscreen
      '';
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
      # "skim"
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
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.fish}/bin/fish'';
    stateVersion = 4;
  };
}
