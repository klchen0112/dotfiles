#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#
{ inputs
, outputs
, config
, pkgs
, username
, system
, ...
}: {

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];

    config.allowUnfree = true; # Allow proprietary software.
  };

  users.users.${username} = {
    # macOS user
    home = "/Users/${username}";
    shell = pkgs.fish; # Default shell
  };

  fonts = {
    # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      inputs.apple-fonts.packages.${pkgs.system}.sf-pro
      inputs.apple-fonts.packages.${pkgs.system}.sf-compact
      inputs.apple-fonts.packages.${pkgs.system}.sf-mono
      inputs.apple-fonts.packages.${pkgs.system}.sf-arabic
      nerdfonts

      jetbrains-mono
      # cascadia-code
      # comic-mono
      # fira-code
      ibm-plex
      roboto-mono
      twemoji-color-font
      # mononoki
      # symbola
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
      # iosevka
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

  services.activate-system.enable = true;
  services.nix-daemon.enable = true; # Auto upgrade daemon
  services.emacs = {
    enable = true;
    package = pkgs.emacs29;
  };


  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {

      layout = "bsp";
      external_bar = "all:20:60";

      top_padding = 50;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      window_gap = 10;

      mouse_follows_focus = "off";
      focus_follows_mouse = "off";
      window_topmost = "off";

      # active_window_border_color = color.focused;
      # normal_window_border_color = color.normal;
      # insert_feedback_color = color.preselect;
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
    extraConfig =
      ''
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

  services.skhd = {
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

  services.sketchybar = {
    enable = true;
    extraPackages = [ pkgs.jq ];
    # this code from https://github.com/FelixKratz/dotfiles
    config =
      let
        sketchybar_scripts = ./sketchybar;
      in
      ''
        #!/usr/bin/env sh
        SKETCHBAR_BIN="/run/current-system/sw/bin/sketchybar"

        PLUGIN_DIR="$HOME/.config/sketchybar/plugins"
        ITEM_DIR="$HOME/.config/sketchybar/items"

        LABEL_FONT_FAMILY="苹方-简"
        LABEL_FONT_STYLE="Medium"
        LABEL_FONT_SIZE="14"
        LABEL_COLOR=0xffdfe1ea
        ICON_FONT_FAMILY="Hack Nerd Font"
        ICON_FONT_STYLE="Regular"
        ICON_FONT_SIZE="16"
        BAR_COLOR=0xee1a1c26
        LABEL_COLOR=0xffdfe1ea
        BACKGROUND_COLOR=0xff252731
        BACKGROUND_HEIGHT=33
        BACKGROUND_CORNER_RADIUS=20
        PADDINGS=3

        $SKETCHBAR_BIN --bar height=50                                                     \
        corner_radius=14                                              \
        border_width=0                                                \
        margin=95                                                     \
        blur_radius=0                                                 \
        position=top                                                  \
        padding_left=4                                                \
        padding_right=4                                               \
        color=$BAR_COLOR                                              \
        topmost=off                                                   \
        sticky=on                                                     \
        font_smoothing=off                                            \
        y_offset=10                                                   \
        notch_width=0                                                 \
        \
        --default drawing=on                                                    \
        updates=when_shown                                            \
        label.font.family="$LABEL_FONT_FAMILY"                        \
        label.font.style=$LABEL_FONT_STYLE                            \
        label.font.size=$LABEL_FONT_SIZE                              \
        label.padding_left=$PADDINGS                                  \
        label.padding_right=$PADDINGS                                 \
        icon.font.family="$ICON_FONT_FAMILY"                          \
        icon.font.style=$ICON_FONT_STYLE                              \
        icon.font.size=$ICON_FONT_SIZE                                \
        icon.padding_left=$PADDINGS                                   \
        icon.padding_right=$PADDINGS                                  \
        background.padding_right=$PADDINGS                            \
        background.padding_left=$PADDINGS                             \

        $SKETCHBAR_BIN --add event window_focus
        $SKETCHBAR_BIN --add event title_change

        . "$ITEM_DIR/menu.sh"
        . "$ITEM_DIR/system.sh"
        . "$ITEM_DIR/window_title.sh"

        . "$ITEM_DIR/time.sh"
        . "$ITEM_DIR/battery.sh"

        . "$ITEM_DIR/bluetooth.sh"
        . "$ITEM_DIR/vpn.sh"
        . "$ITEM_DIR/wifi.sh"

        $SKETCHBAR_BIN --update


      '';
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
      experimental-features = nix-command flakes
    '';

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
      "homebrew/services"
      "laishulu/macism"
    ];
    brews = [
      "macism"
      "mas"
      "blueutil"
      "ifstat"
      "cava"
    ];
    casks = [

      # "sunloginclient"
      "adrive"
      "snipaste"
      "google-chrome"
      "steam"
      "appcleaner"
      # "hammerspoon"
      # "authy"
      # "hiddenbar"
      # "telegram"
      "baidunetdisk"
      # "iterm2"
      "balenaetcher"
      "keyboardcleantool"
      "todesk"
      # "marginnote"
      "vial"
      "dash"
      # "nutstore"
      "omnidisksweeper"
      # "discord"
      # "xnviewmp"
      # "openvpn-connect"
      # "zotero"
      # "skim"
      # "via"
      #"miniconda"
      "activitywatch"
      # "openscad"
      "qmk-toolbox"
      "mathpix-snipping-tool"
      # "sing-box"
      "sfm"
      "marginnote"
      "zotero"
      "background-music"
    ];
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
        _HIHideMenuBar = true;
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
    # activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.fish}/bin/fish'' ;
    stateVersion = 4;
  };
}

