{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.aerospace = {
    enable = pkgs.stdenv.isDarwin;
    userSettings = builtins.fromTOML (builtins.readFile ./aerospace.toml);
  };

  home.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.symbols-only
    sketchybar-app-font
    blueutil
    coreutils
    curl
    gh
    gh-notify
    gnugrep
    gnused
    jankyborders
    jq
    aerospace
    sketchybarhelper
    dynamic-island-helper
    wttrbar

  ];
  home.shellAliases = {
    restart-sketchybar = ''launchctl kickstart -k gui/"$(id -u)"/org.nix-community.home.sketchybar'';
  };
  programs.sketchybar = {
    enable = pkgs.stdenv.isDarwin;
    service.enable = pkgs.stdenv.isDarwin;
    configType = "lua";
    sbarLuaPackage = pkgs.sbarlua;
    extraPackages = with pkgs; [
      blueutil
      coreutils
      curl
      gh
      gh-notify
      gnugrep
      gnused
      jankyborders
      jq
      aerospace
      sketchybarhelper
      dynamic-island-helper
      wttrbar
    ];
    ## config from https://github.com/khaneliman/khanelinix
    config = {
      source = ./config;
      recursive = true;
    };
  };
  xdg.configFile = {
    "dynamic-island-sketchybar" = {
      source = lib.cleanSourceWith { src = lib.cleanSource ./dynamic-island-sketchybar/.; };

      recursive = true;
    };
    "sketchybar/icon_map.lua".source =
      "${pkgs.sketchybar-app-font}/lib/sketchybar-app-font/icon_map.lua";
    "sketchybar/colors.lua".text = ''
      #!/usr/bin/env lua
      local colors = {
      	bg = 0xff${config.lib.stylix.colors.base00},
        light_bg = 0xff${config.lib.stylix.colors.base01},
        selection_bg = 0xff${config.lib.stylix.colors.base02},
        comment_bg = 0xff${config.lib.stylix.colors.base03},
        dark_text = 0xff${config.lib.stylix.colors.base04},
      	text = 0xff${config.lib.stylix.colors.base05},
        light_text = 0xff${config.lib.stylix.colors.base06},
        light_bg2 = 0xff${config.lib.stylix.colors.base07},
      	blue = 0xff${config.lib.stylix.colors.base0D},
      	green = 0xff${config.lib.stylix.colors.base0B},
      	yellow = 0xff${config.lib.stylix.colors.base0A},
        purple = 0xff${config.lib.stylix.colors.base0E},
        brown = 0xff${config.lib.stylix.colors.base0F},
        cyan = 0xff${config.lib.stylix.colors.base0C},
        orange = 0xff${config.lib.stylix.colors.base09},
      	red = 0xff${config.lib.stylix.colors.base08},

      }

      colors.random_cat_color = {
      	colors.blue,
      	colors.green,
      	colors.yellow,
      	colors.red,
      	colors.mauve,
      	colors.pink,
      	colors.purple,
      	colors.brown,
      }

      colors.getRandomCatColor = function()
      	return colors.random_cat_color[math.random(1, #colors.random_cat_color)]
      end

      return colors
    '';
  };
  services.jankyborders = {
    enable = pkgs.stdenv.isDarwin;
    settings = {
      style = "round";
      width = 6.0;
      hidpi = "on";
      active_color = "${config.lib.stylix.colors.base0D}";
      inactive_color = "${config.lib.stylix.colors.base03}";
    };
  };
}
