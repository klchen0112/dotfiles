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
      jq
      aerospace
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
    "sketchybar/wm_config.lua".text = ''
      -- Window manager configuration for sketchybar
      return {
        use_aerospace = true,
        use_yabai = false
        },
      }
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
