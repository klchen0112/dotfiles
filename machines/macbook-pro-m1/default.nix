#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#
{ config
, pkgs
, username
, system
, inputs
, ...
}: {
  users.users.${username} = {
    # macOS user
    home = "/Users/${username}";
    shell = pkgs.fish; # Default shell
  };

  fonts = {
    # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      # jetbrains-mono
      # cascadia-code
      # comic-mono
      # fira-code
      ibm-plex
      roboto-mono
      twemoji-color-font
      # mononoki
      symbola
      # noto-fonts
      # noto-fonts-extra
      # noto-fonts-emoji
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
    shells = with pkgs; [ bashInteractive fish ]; # Default shell
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
      fontconfig
      home-manager
      coreutils
      cachix
      jq # for yabai json parser
      # sketchybar
      gzip
      nixpkgs-fmt
    ];
  };

  services = {
    activate-system.enable = true;
    # ariang.enable = true;
    nix-daemon.enable = true; # Auto upgrade daemon
    emacs = {
      enable = false;
      package = pkgs.emacs-unstable;
      # https://github.com/nix-community/nix-doom-emacs/blob/master/docs/reference.md#emacs-daemon
      # package = inputs.nix-doom-emacs.packages.${system}.doom-emacs.override {
      #  doomPrivateDir = ../../doom;
      #  emacsPackage = pkgs.emacs-unstable;
      # };
    };

    yabai = {
      enable = true;
      enableScriptingAddition = true;
      config =
        let
          gaps = {
            top = 0;
            bottom = 10;
            left = 0;
            right = 0;
            inner = 0;
          };
          color = {
            focused = "0xE0808080";
            normal = "0x00010101";
            preselect = "0xE02d74da";
          };
        in
        {
          debug_output = "on";
          external_bar = "all:35:0";
          layout = "bsp";
          top_padding = gaps.top;
          bottom_padding = gaps.bottom;
          left_padding = gaps.left;
          right_padding = gaps.right;
          window_gap = gaps.inner;

          mouse_follows_focus = "off";
          focus_follows_mouse = "off";
          window_topmost = "off";

          active_window_border_color = color.focused;
          normal_window_border_color = color.normal;
          insert_feedback_color = color.preselect;
          window_zoom_persist = "off";
          window_placement = "second_child";
          window_shadow = "float";

          window_border = "on";
          window_border_radius = 10;
          window_border_width = 2;
          window_border_blur = "off";
          window_animation_duration = 0.0;

          window_opacity = "off";
          window_opacity_duration = 0.0;
          active_window_opacity = 1.0;
          normal_window_opacity = 0.90;
          split_ratio = 0.50;

          auto_balance = "off";

          mouse_modifier = "fn";
          mouse_action1 = "move";
          mouse_action2 = "resize";
          mouse_drop_action = "swap";
        };
      extraConfig = ''
        #!/usr/bin/env sh

        # Unload the macOS WindowManager process

        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        yabai -m signal --add event=window_focused action="sketchybar --trigger window_focus"
        yabai -m signal --add event=display_added action="sleep 2 && $HOME/.config/yabai/create_spaces.sh"
        yabai -m signal --add event=display_removed action="sleep 1 && $HOME/.config/yabai/create_spaces.sh"
        yabai -m signal --add event=window_created action="sketchybar --trigger windows_on_spaces"
        yabai -m signal --add event=window_destroyed action="sketchybar --trigger windows_on_spaces"
        ## auto create Display and move to window
        $HOME/.config/yabai/create_spaces.sh
        yabai -m config window_gap     5
        yabai -m config window_opacity on
        yabai -m config active_window_opacity 1.0
        yabai -m config normal_window_opacity 0.95
        # Space config
        yabai -m config --space 5 layout float
        yabai -m config --space 10 layout float

        # ===== Rules ==================================
        yabai -m rule --add label="emacs" subrole!="^(AXFloatingWindow)$" app="Emacs" manage=on
        yabai -m rule --add label="Finder" app="^(Finder|访达)$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
        yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
        yabai -m rule --add label="macfeh" app="^macfeh$" manage=off
        yabai -m rule --add label="System Settings" app="^(System Settings|系统偏好设置)$" title=".*" manage=off
        yabai -m rule --add label="Calendar" app="^(Calendar|日历)$" title=".*" manage=off
        yabai -m rule --add label="App Store" app="^App Store$" manage=off
        yabai -m rule --add label="Activity Monitor" app="^Activity Monitor$" manage=off
        yabai -m rule --add label="KeePassXC" app="^KeePassXC$" manage=off
        yabai -m rule --add label="Calculator" app="^Calculator$" manage=off
        yabai -m rule --add label="Dictionary" app="^Dictionary$" manage=off
        yabai -m rule --add label="mpv" app="^mpv$" manage=off
        yabai -m rule --add label="Software Update" title="Software Update" manage=off
        yabai -m rule --add app="Raycast" manage=off
        yabai -m rule --add app="Bitwarden" manage=off
        yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
        yabai -m rule --add app="Dash" manage=off

        yabai -m rule --add label=musicapp app="Plexamp" space=10 manage=off

        yabai -m rule --add app="^(Spark)$" --toggle float space=10 manage=on
        yabai -m rule --add app="^(微信|WeChat)$" --toggle float space=10 manage=off
        yabai -m rule --add app="^(QQ)$" --toggle float space=10 manage=off
        yabai -m rule --add app="^(钉钉|DingTalk)$"--toggle float space=10 manage=off
        yabai -m rule --add app="^(Telegram)$" --toggle float space=10 manage=off
        yabai -m rule --add app="^(Discord)$"--toggle float space=10 manage=off

      '';
    };
    skhd = {
      enable = true;
      skhdConfig =
        let
          keycodes = import ./keycodes.nix;
          current_workspace_prefix = "ctrl + alt";
          current_workspace_move_prefix = "ctrl + shift";
          diffent_workspace_move_prefix = "shift + alt + ctrl";
          size_chang_prefix = "cmd + ctrl";
          insert_prefix = "shift + alt";
          high_prefix = "shift + ctrl + cmd";
        in
        ''
          #!/usr/bin/env sh
          ## Current workspace move and focus
          # focus window : current_workspace_prefix - {p, n, b, f}
          ${current_workspace_prefix} - ${keycodes.B} : yabai -m window --focus west  || yabai -m display --focus west
          ${current_workspace_prefix} - ${keycodes.N} : yabai -m window --focus south || yabai -m display --focus south
          ${current_workspace_prefix} - ${keycodes.P} : yabai -m window --focus north || yabai -m display --focus north
          ${current_workspace_prefix} - ${keycodes.F} : yabai -m window --focus east  || yabai -m display --focus east
          ${current_workspace_prefix} - ${keycodes.A} : yabai -m window --focus first || yabai -m display --focus north
          ${current_workspace_prefix} - ${keycodes.E} : yabai -m window --focus last  || yabai -m display --focus east

          ## Current workspace window adjust use ${current_workspace_move_prefix} as prefix
          # Make window zoom to fullscreen: current_workspace_prefix - ${keycodes.Z}
          ${current_workspace_move_prefix} - ${keycodes.Z} : yabai -m window --toggle zoom-fullscreen;

          # Mirror Space on X and Y Axis: current_workspace_move_prefix - {x, y,r}
          ${current_workspace_move_prefix} - ${keycodes.X} : yabai -m space --mirror x-axis
          ${current_workspace_move_prefix} - ${keycodes.Y} : yabai -m space --mirror y-axis
          ${current_workspace_move_prefix} - ${keycodes.R} : yabai -m space --rotate 90


          # Enable / Disable gaps in current workspace
          ${current_workspace_move_prefix} - ${keycodes.G} : yabai -m space --toggle padding; yabai -m space --toggle gap

          # toggle whether the focused window should have a border
          ${current_workspace_move_prefix} - ${keycodes.W} : yabai -m window --toggle border
          # toggle whether the focused window should be shown on all spaces
          ${current_workspace_move_prefix} - ${keycodes.S} : yabai -m window --toggle sticky
          # toggle whether the focused window should be tiled (only on bsp spaces)
          ${current_workspace_move_prefix} - ${keycodes.Space} : yabai -m window --toggle float

          ## Current workspace move
          # Moving windows in spaces: current_workspace_move_prefix - {p, n, b, f}
          ${current_workspace_move_prefix} - ${keycodes.B} : yabai -m window --warp west  || (yabai -m window --display west  ; yabai -m display --focus west )
          ${current_workspace_move_prefix} - ${keycodes.N} : yabai -m window --warp south || (yabai -m window --display south ; yabai -m display --focus south)
          ${current_workspace_move_prefix} - ${keycodes.P} : yabai -m window --warp north || (yabai -m window --display north ; yabai -m display --focus north)
          ${current_workspace_move_prefix} - ${keycodes.F} : yabai -m window --warp east  || (yabai -m window --display east  ; yabai -m display --focus east )

          ## Diffent Workspace Operation (size_chang_prefix - ...)
          # Moving windows between spaces: diffent_workspace_move_prefix - {1, 2, 3, 4, p, n,r } (Assumes 4 Spaces Max per Display)
          ${current_workspace_move_prefix} - 1 : yabai -m window --space 1; yabai -m space --focus 1;
          ${current_workspace_move_prefix} - 2 : yabai -m window --space 2; yabai -m space --focus 2;
          ${current_workspace_move_prefix} - 3 : yabai -m window --space 3; yabai -m space --focus 3;
          ${current_workspace_move_prefix} - 4 : yabai -m window --space 4; yabai -m space --focus 4;
          ${current_workspace_move_prefix} - 5 : yabai -m window --space 5; yabai -m space --focus 5;
          ${current_workspace_move_prefix} - 6 : yabai -m window --space 6; yabai -m space --focus 6;
          ${current_workspace_move_prefix} - 7 : yabai -m window --space 7; yabai -m space --focus 7;
          ${current_workspace_move_prefix} - 8 : yabai -m window --space 8; yabai -m space --focus 8;
          ${current_workspace_move_prefix} - 9 : yabai -m window --space 9; yabai -m space --focus 9;
          ${current_workspace_move_prefix} - 0 : yabai -m window --space 10; yabai -m space --focus 10;
          # ${diffent_workspace_move_prefix} - ${keycodes.P} : yabai -m window --space prev ; yabai -m space --focus prev;
          # ${diffent_workspace_move_prefix} - ${keycodes.N} : yabai -m window --space next ; yabai -m space --focus next;
          ${current_workspace_move_prefix} - ${keycodes.A} : yabai -m window --space first; yabai -m space --focus first;
          ${current_workspace_move_prefix} - ${keycodes.E} : yabai -m window --space last ; yabai -m space --focus last;
          ${current_workspace_move_prefix} - ${keycodes.R} : yabai -m window --space recent; yabai -m space --focus recent;

          # toggle fullscreen or split
          # ${diffent_workspace_move_prefix}  - ${keycodes.F} : yabai -m window --toggle native-fullscreen
          # ${diffent_workspace_move_prefix}  - ${keycodes.S} : yabai -m window --toggle split && yabai -m space --balance

          ## Resize (size_chang_prefix - ...)
          # Resize windows: size_chang_prefix - {p, n, b, f}
          ${size_chang_prefix} - ${keycodes.B} : yabai -m window --resize right:-100:0  || yabai -m window --resize left:-100:0
          ${size_chang_prefix} - ${keycodes.N} : yabai -m window --resize bottom:0:100  || yabai -m window --resize top:0:100
          ${size_chang_prefix} - ${keycodes.P} : yabai -m window --resize bottom:0:-100 || yabai -m window --resize top:0:-100
          ${size_chang_prefix} - ${keycodes.F} : yabai -m window --resize right:100:0   || yabai -m window --resize left:100:0
          # Equalize size of windows
          ${size_chang_prefix} - ${keycodes.E} : yabai -m space --balance;

          ## Insertion (insert_prefix - ...)
          # Set insertion point for focused container: ${insert_prefix}  - {p,n,b,f,s}
          # ${insert_prefix} - ${keycodes.B} : yabai -m window --insert west
          # ${insert_prefix} - ${keycodes.N} : yabai -m window --insert south
          # ${insert_prefix} - ${keycodes.P} : yabai -m window --insert north
          # ${insert_prefix} - ${keycodes.F} : yabai -m window --insert east
          # ${insert_prefix} - ${keycodes.S} : yabai -m window --insert stack
          ## high (insert_prefix - ...)
          ${high_prefix} - ${keycodes.X} :  \
            /usr/bin/env osascript <<< \
          "display notification \"Restarting Yabai\" with title \"Yabai\""; \
          launchctl kickstart -k gui/''${UID}/org.nixos.yabai && launchctl kickstart -k gui/''${UID}/org.nixos.skhd
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
      "microsoft-word" = 462054704;
      "microsoft-powerpoint" = 462062816;
      "microsoft-excel" = 462058435;
      onedrive = 823766827;
      "goodnotes-5" = 1444383602;
      xcode = 497799835;
    };

    taps = [
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/core"
      "homebrew/services"
      "laishulu/macism"
      "FelixKratz/formulae"
    ];
    brews = [
      "mas"
      "pngpaste" # for emacs download clipboard
      "macism"
      "sketchybar"
    ];
    casks = [
      "font-sf-pro"
      "font-sf-compact"
      "font-sf-mono"
      # "sunloginclient"
      "adrive"
      "snipaste"
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
      "marginnote"
      "vial"
      "dash"
      # "nutstore"
      "omnidisksweeper"
      # "discord"
      "plexamp"
      "xnviewmp"
      "openvpn-connect"
      "zotero"
      # "skim"
      # "via"
      "logseq"
      #"miniconda"
      "activitywatch"
      # "openscad"
      "qmk-toolbox"
      "mathpix-snipping-tool"
      "tidgi"
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
      auto-optimise-store = true;

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
      loginwindow.GuestEnabled = false;
      NSGlobalDomain = {
        # Global macOS system settings
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        AppleShowAllExtensions = true;

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
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
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
    # activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.fish}/bin/fish'';
    stateVersion = 4;
  };
}
