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
      jq # for yabai json parser
    ];
  };

  services = {
    activate-system.enable = true;
    # ariang.enable = true;
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

        yabai -m config mouse_follows_focus         on
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
        yabai -m rule --add label=emacs app=Emacs manage=on
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
        yabai -m rule --add app="Raycast" manage=off
        yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
        yabai -m rule --add app="Dash"                manage="off"
        yabai -m rule --add app="Plexamp"             manage="off"
        # ===== Signals ================================

      '';
    };
    skhd = {
      enable = true;
      skhdConfig = let
        current_workspace_prefix = "ctrl + alt";
        current_workspace_focus_and_move_prefix = current_workspace_prefix;
        current_workspace_move_prefix = "shift + alt";
        diffent_workspace_move_prefix = "ctrl + cmd";
        size_chang_prefix = "shift + alt";
        insert_prefix = "shift + ctrl + lalt";
      in ''
        ## Current workspace move and focus
        # move window and focus: current_workspace_prefix - {p, n, b, f}
        ${current_workspace_focus_and_move_prefix} - b : yabai -m window --focus west || yabai -m display --focus west
        ${current_workspace_focus_and_move_prefix} - n : n -m window --focus south || yabai -m display --focus south
        ${current_workspace_focus_and_move_prefix} - p : yabai -m window --focus north || yabai -m display --focus north
        ${current_workspace_focus_and_move_prefix} - f : yabai -m window --focus east || yabai -m display --focus east

        ## Current workspace window adjust
        # Make window zoom to fullscreen: current_workspace_prefix - f
        ${current_workspace_prefix} - f : yabai -m window --toggle zoom-fullscreen;

        # Mirror Space on X and Y Axis: current_workspace_move_prefix  - {x, y,r}
        ${current_workspace_prefix} - x : yabai -m space --mirror x-axis
        ${current_workspace_prefix} - y : yabai -m space --mirror y-axis
        ${current_workspace_prefix} - r : yabai -m space --rotate 90

        # Equalize size of windows
        ${current_workspace_prefix} - e : yabai -m space --balance
        # Enable / Disable gaps in current workspace
        ${current_workspace_prefix} - g : yabai -m space --toggle padding; yabai -m space --toggle gap
        # toggle whether the focused window should be tiled (only on bsp spaces)
        ${current_workspace_prefix} - space : yabai -m window --toggle float
        # toggle whether the focused window should have a border
        ${current_workspace_prefix} - w : yabai -m window --toggle border
        # toggle whether the focused window should be shown on all spaces
        ${current_workspace_prefix} - s : yabai -m window --toggle sticky

        ## Current workspace move
        # Moving windows in spaces: current_workspace_move_prefix - {p, n, b, f}
        ${current_workspace_move_prefix} - b : yabai -m window --warp west || $(yabai -m window --display west && yabai -m display --focus west && yabai -m window --warp last) || yabai -m window --move rel:-10:0
        ${current_workspace_move_prefix} - n : yabai -m window --warp south || $(yabai -m window --display south && yabai -m display --focus south) || yabai -m window --move rel:0:10
        ${current_workspace_move_prefix}- p : yabai -m window --warp north || $(yabai -m window --display north && yabai -m display --focus north) || yabai -m window --move rel:0:-10
        ${current_workspace_move_prefix} - f : yabai -m window --warp east || $(yabai -m window --display east && yabai -m display --focus east && yabai -m window --warp first) || yabai -m window --move rel:10:0



        ## Diffent Workspace Operation (size_chang_prefix - ...)
        # Moving windows between spaces: diffent_workspace_move_prefix - {1, 2, 3, 4, p, n,r } (Assumes 4 Spaces Max per Display)
        ${diffent_workspace_move_prefix} - 1 :  yabai -m window --space 1
        ${diffent_workspace_move_prefix} - 2 :  yabai -m window --space 2
        ${diffent_workspace_move_prefix} - 3 : yabai -m window --space 3
        ${diffent_workspace_move_prefix} - 4 : yabai -m window --space 4
        ${diffent_workspace_move_prefix} - p : yabai -m window --space prev; yabai -m space --focus prev;
        ${diffent_workspace_move_prefix} - n : yabai -m window --space next; yabai -m space --focus next;
        ${diffent_workspace_move_prefix} - p : yabai -m window --space recent; yabai -m space --focus prev;

        ## Resize (size_chang_prefix - ...)
        # Resize windows: size_chang_prefix - {p, n, b, f}
        ${size_chang_prefix} - b    : yabai -m window --resize right:-100:0 || yabai -m window --resize left:-100:0
        ${size_chang_prefix} - n    : yabai -m window --resize bottom:0:100 || yabai -m window --resize top:0:100
        ${size_chang_prefix} - p    : yabai -m window --resize bottom:0:-100 || yabai -m window --resize top:0:-100
        ${size_chang_prefix} - f : yabai -m window --resize right:100:0 || yabai -m window --resize left:100:0

        ## Insertion (insert_prefix - ...)
        # Set insertion point for focused container: shift + ctrl + lalt - {p,n,b,f,s}
        ${insert_prefix} - b : yabai -m window --insert west
        ${insert_prefix} - n : yabai -m window --insert south
        ${insert_prefix} - p : yabai -m window --insert north
        ${insert_prefix} - f : yabai -m window --insert east
        ${insert_prefix} - s : yabai -m window --insert stack
      '';
    };
    # spacebar = {
    #   enable = true;
    #   package = pkgs.spacebar;
    #   config = {
    #     position = "top";
    #     display = "main";
    #     height = 26;
    #     title = "on";
    #     spaces = "on";
    #     clock = "on";
    #     power = "on";
    #     padding_left = 20;
    #     padding_right = 20;
    #     spacing_left = 25;
    #     spacing_right = 15;
    #     text_font = ''"Menlo:Regular:12.0"'';
    #     icon_font = ''"Font Awesome 5 Free:Solid:12.0"'';
    #     background_color = "0xff202020";
    #     foreground_color = "0xffa8a8a8";
    #     power_icon_color = "0xffcd950c";
    #     battery_icon_color = "0xffd75f5f";
    #     dnd_icon_color = "0xffa8a8a8";
    #     clock_icon_color = "0xffa8a8a8";
    #     power_icon_strip = " ";
    #     space_icon = "•";
    #     space_icon_strip = "1 2 3 4 5 6 7 8 9 10";
    #     spaces_for_all_displays = "on";
    #     display_separator = "on";
    #     display_separator_icon = "";
    #     space_icon_color = "0xff458588";
    #     space_icon_color_secondary = "0xff78c4d4";
    #     space_icon_color_tertiary = "0xfffff9b0";
    #     clock_icon = "";
    #     dnd_icon = "";
    #     clock_format = ''"%d/%m/%y %R"'';
    #     right_shell = "on";
    #     right_shell_icon = "";
    #     right_shell_command = "whoami";
    #   };
    # };
  };

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
      tencent-meeting = 1484048379;
      emby = 992180193;
      "microsoft-word" = 462054704;
      "microsoft-powerpoint" = 462062816;
      "microsoft-excel" = 462058435;
      onedrive = 823766827;
      "goodnotes-5" = 1444383602;
      xcode = 497799835;
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
      # "sunloginclient"
      # "adrive"
      "snipaste"
      "anki"
      "google-chrome"
      "steam"
      "appcleaner"
      # "hammerspoon"
      "sublime-text"
      # "authy"
      # "hiddenbar"
      # "telegram"
      "baidunetdisk"
      # "iterm2"
      "balenaetcher"
      "keyboardcleantool"
      "todesk"
      "calibre"
      "marginnote"
      "vial"
      "dash"
      # "nutstore"
      "omnidisksweeper"
      "vlc"
      # "discord"
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
