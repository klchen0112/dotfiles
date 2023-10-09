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

    config = {
      allowUnfree = true; # Allow proprietary software.
      allowUnfreePredicate = (_: true);
    };
  };

  users.users.${username} = {
    # macOS user
    home = "/Users/${username}";
    name = "${username}";
    shell = pkgs.fish; # Default shell
  };

  fonts = {
    # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      sf-pro
      sf-compact
      sf-mono
      sf-arabic
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

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
  programs.fish.enable = true;

  environment = {
    shells = with pkgs; [ fish bash ]; # Default shell
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
      cachix
      # sketchybar
      fontconfig
    ];
  };

  services.activate-system.enable = true;
  services.nix-daemon.enable = true; # Auto upgrade daemon
  services.emacs = {
    enable = true;
    package =
      # if pkgs.stdenv.hostPlatform.isDarwin then
      #   pkgs.emacs29-macport
      # else
      pkgs.emacs29;

  };


  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {

      layout = "bsp";
      external_bar = "all:50:0";

      top_padding = 0;
      bottom_padding = 0;
      left_padding = 0;
      right_padding = 0;
      window_gap = 5;

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
      let yabai_script = ./yabai;
      in
      ''
        #!/usr/bin/env sh

        # Unload the macOS WindowManager process

        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        yabai -m signal --add event=window_focused action="sketchybar --trigger window_focus"
        yabai -m signal --add event=display_added action="sleep 2 && ${yabai_script}/create_spaces.sh"
        yabai -m signal --add event=display_removed action="sleep 1 && ${yabai_script}/yabai/create_spaces.sh"
        yabai -m signal --add event=window_created action="sketchybar --trigger windows_on_spaces"
        yabai -m signal --add event=window_destroyed action="sketchybar --trigger windows_on_spaces"
        ## auto create Display and move to window
        ${yabai_script}/create_spaces.sh


        # ===== Rules ==================================


        # code
        yabai -m rule --add app="WezTerm" space=^1
        yabai -m rule --add label="emacs" subrole!="^(AXFloatingWindow)$" app="^Emacs$" manage=on
        yabai -m rule --add app="Dash" manage=off

        # browser
        yabai -m rule --add app="Google Chrome"
        # chat
        yabai -m rule --add app="^(Spark)$" --toggle float space=3 manage=on
        yabai -m rule --add app="^(微信|WeChat)$" --toggle float space=3 manage=off
        yabai -m rule --add app="^(QQ)$" --toggle float space=3 manage=off

        yabai -m rule --add app="^(Telegram)$" --toggle float space=3 manage=off
        yabai -m rule --add app="^(Discord)$"--toggle float space=3 manage=off

        # work
        yabai -m rule --add app="^(钉钉|DingTalk)$"--toggle float space=4 manage=off
        yabai -m rule --add app="飞书" space=^4 manage=off

        # mail
        yabai -m rule --add app="Spark" space=^4 manage=off

        # music
        yabai -m rule --add app="Plexamp" space=^6 manage=off

        # video
        yabai -m rule --add label="mpv" app="^mpv$" manage=off space=^8

        # system
        yabai -m rule --add label="Finder" app="^(Finder|访达)$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
        yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
        yabai -m rule --add label="macfeh" app="^macfeh$" manage=off
        yabai -m rule --add label="System Settings" app="^(System Settings|系统偏好设置)$" title=".*" manage=off
        yabai -m rule --add label="Calendar" app="^(Calendar|日历)$" title=".*" manage=off
        yabai -m rule --add label="App Store" app="^App Store$" manage=off
        yabai -m rule --add label="Activity Monitor" app="^Activity Monitor$" manage=off
        yabai -m rule --add label="Calculator" app="^Calculator$" manage=off
        yabai -m rule --add label="Dictionary" app="^Dictionary$" manage=off
        yabai -m rule --add label="Software Update" title="Software Update" manage=off
        yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off

        yabai -m rule --add app="Raycast" manage=off
        yabai -m rule --add app="Bitwarden" manage=off
      '';
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      # add an on_enter command to the default mode
      #
      # defines a new mode 'test' with an on_enter command, that captures keypresses
      # :: default @ : yabai -m config active_window_border_color 0xff24ccaa
      :: yabai_mode_focus @ : yabai -m config active_window_border_color 0xffF3F8F8
      :: yabai_mode_move  @ : yabai -m config active_window_border_color 0xffFAE7A1
      :: yabai_mode_size  @ : yabai -m config active_window_border_color 0xffA07265
      # yabai mode
      # yabai_mode_focus, yabai_mode_size < ctrl - 1 : yabai -m space --focus 1;
      # yabai_mode_focus, yabai_mode_size < ctrl - 2 : yabai -m space --focus 2;
      # yabai_mode_focus, yabai_mode_size < ctrl - 3 : yabai -m space --focus 3;
      # yabai_mode_focus, yabai_mode_size < ctrl - 4 : yabai -m space --focus 4;
      # yabai_mode_focus, yabai_mode_size < ctrl - 5 : yabai -m space --focus 5;
      # yabai_mode_focus, yabai_mode_size < ctrl - 6 : yabai -m space --focus 6;
      # yabai_mode_focus, yabai_mode_size < ctrl - 7 : yabai -m space --focus 7;
      # yabai_mode_focus, yabai_mode_size < ctrl - 8 : yabai -m space --focus 8;
      # yabai_mode_focus, yabai_mode_size < ctrl - 9 : yabai -m space --focus 9;
      # yabai_mode_focus, yabai_mode_size < ctrl - 0 : yabai -m space --focus 10;
      ## Current workspace focus
      # focus window : current_workspace_prefix - {p, n, b, f}
      ctrl + cmd - y ; yabai_mode_focus
      yabai_mode_focus < ctrl + cmd - y ; default

      yabai_mode_focus < shift - b : yabai -m window --focus west  || yabai -m display --focus west
      yabai_mode_focus < shift - n : yabai -m window --focus south || yabai -m display --focus south
      yabai_mode_focus < shift - p : yabai -m window --focus north || yabai -m display --focus north
      yabai_mode_focus < shift - f : yabai -m window --focus east  || yabai -m display --focus east
      yabai_mode_focus < shift - a : yabai -m window --focus first || yabai -m display --focus north
      yabai_mode_focus < shift - e : yabai -m window --focus last  || yabai -m display --focus east

      yabai_mode_focus < shift - z : yabai -m window --toggle zoom-fullscreen;

      ## Current workspace move
      ctrl + cmd - m ; yabai_mode_move
      yabai_mode_move < ctrl + cmd - m ; default

      yabai_mode_move < shift - b : yabai -m window --swap west  || (yabai -m window --display west  ; yabai -m display --focus west )
      yabai_mode_move < shift - n : yabai -m window --swap south || (yabai -m window --display south ; yabai -m display --focus south)
      yabai_mode_move < shift - p : yabai -m window --swap north || (yabai -m window --display north ; yabai -m display --focus north)
      yabai_mode_move < shift - f : yabai -m window --swap east  || (yabai -m window --display east  ; yabai -m display --focus east )

      yabai_mode_move < shift - x : yabai -m space --mirror x-axis
      yabai_mode_move < shift - y : yabai -m space --mirror y-axis
      yabai_mode_move < shift - r : yabai -m space --rotate 90

      yabai_mode_move < ctrl - 1 : yabai -m window --space 1; yabai -m space --focus 1;
      yabai_mode_move < ctrl - 2 : yabai -m window --space 2; yabai -m space --focus 2;
      yabai_mode_move < ctrl - 3 : yabai -m window --space 3; yabai -m space --focus 3;
      yabai_mode_move < ctrl - 4 : yabai -m window --space 4; yabai -m space --focus 4;
      yabai_mode_move < ctrl - 5 : yabai -m window --space 5; yabai -m space --focus 5;
      yabai_mode_move < ctrl - 6 : yabai -m window --space 6; yabai -m space --focus 6;
      yabai_mode_move < ctrl - 7 : yabai -m window --space 7; yabai -m space --focus 7;
      yabai_mode_move < ctrl - 8 : yabai -m window --space 8; yabai -m space --focus 8;
      yabai_mode_move < ctrl - 9 : yabai -m window --space 9; yabai -m space --focus 9;
      yabai_mode_move < ctrl - 0 : yabai -m window --space 10; yabai -m space --focus 10;

      ## Current workspace size change
      ctrl + cmd - s ; yabai_mode_size
      yabai_mode_size < ctrl + cmd - s ; default
      yabai_mode_size < shift - b : yabai -m window --resize right:-100:0  || yabai -m window --resize left:-100:0
      yabai_mode_size < shift - n : yabai -m window --resize bottom:0:100  || yabai -m window --resize top:0:100
      yabai_mode_size < shift - p : yabai -m window --resize bottom:0:-100 || yabai -m window --resize top:0:-100
      yabai_mode_size < shift - f : yabai -m window --resize right:100:0   || yabai -m window --resize left:100:0
      yabai_mode_size < shift - x : yabai -m space  --balance x-axis
      yabai_mode_size < shift - y : yabai -m space  --balance y-axis
    '';
  };
  #TODO fix plexamp and cava email
  services.sketchybar = {
    enable = true;
    extraPackages = [ pkgs.jq ];
    # this code from https://github.com/ColaMint/config.git
    config =
      let
        sketchybar_scripts = ./sketchybar;
      in
      ''
        #!/usr/bin/env sh
        SKETCHBAR_BIN="${pkgs.sketchybar}/bin/sketchybar"

        PLUGIN_DIR="${sketchybar_scripts}/plugins"
        ITEM_DIR="${sketchybar_scripts}/items"

        LABEL_FONT_FAMILY="PingFang SC"
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
        BACKGROUND_CORNER_RADIUS=16
        PADDINGS=3

        $SKETCHBAR_BIN --bar height=40                                                     \
        corner_radius=16                                              \
        border_width=0                                                \
        margin=5                                                     \
        blur_radius=0                                                 \
        position=top                                                  \
        padding_left=0                                                \
        padding_right=0                                               \
        color=$BAR_COLOR                                              \
        topmost=off                                                   \
        sticky=on                                                     \
        font_smoothing=off                                            \
        y_offset=5                                                   \
        notch_width=0                                                 \
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
        . "$ITEM_DIR/spaces.sh"



        #. "$ITEM_DIR/cava.sh"
        # . "$ITEM_DIR/feishu.sh"
        . "$ITEM_DIR/wechat.sh"
        . "$ITEM_DIR/email.sh"



        . "$ITEM_DIR/window_title.sh"

        # add right right to left
        . "$ITEM_DIR/tray.sh"
        . "$ITEM_DIR/time.sh"
        . "$ITEM_DIR/system.sh"
        . "$ITEM_DIR/wifi.sh"
        . "$ITEM_DIR/battery.sh"

        #. "$ITEM_DIR/mic.sh"
        #. "$ITEM_DIR/sound.sh"
        # . "$ITEM_DIR/music.sh"

        #. "$ITEM_DIR/bluetooth.sh"
        # . "$ITEM_DIR/vpn.sh"

        $SKETCHBAR_BIN --update


      '';
  };

  # services.sketchybar-bottom = {
  #   enable = false;
  # };


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
    settings = {
      auto-optimise-store = true;
      trusted-users =
        [
          "${username}"
        ];
    };
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
      #. tencent-meeting = 1484048379;
      "microsoft-word" = 462054704;
      "microsoft-powerpoint" = 462062816;
      "microsoft-excel" = 462058435;
      onedrive = 823766827;
      "goodnotes-5" = 1444383602;
      # xcode = 497799835;
    };

    taps = [
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/services"
      "laishulu/macism"
      # "FelixKratz/formulae"
    ];
    brews = [
      "macism"
      "mas"
      "blueutil"
      "ifstat"
    ];
    casks = [
      "squirrel"
      "microsoft-remote-desktop"
      "anki"
      # "sketchybar"
      # "sunloginclient"
      "adrive"
      "snipaste"
      "google-chrome"
      "steam"
      "appcleaner"
      "firefox"
      # "hammerspoon"
      # "authy"
      # "hiddenbar"
      # "telegram"
      "baidunetdisk"
      # "iterm2"
      "balenaetcher"
      "keyboardcleantool"
      # "todesk"
      # "marginnote"
      "vial"
      #"dash"
      # "nutstore"
      "omnidisksweeper"
      # "discord"
      # "xnviewmp"
      # "openvpn-connect"
      # "zotero"
      "skim"
      # "via"
      #"miniconda"
      "activitywatch"
      # "openscad"
      "qmk-toolbox"
      "mathpix-snipping-tool"
      # "sing-box"
      "logi-options-plus"
      "sfm"
      #TODO remove
      "marginnote"
      "zotero"
      "logseq"
      "tencent-meeting"
      "telegram"
      "resilio-sync"
      "via"
      "zerotier-one"
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
      CustomSystemPreferences = {
        NSGlobalDomain.AppleSpacesSwitchOnActivate = false;
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

