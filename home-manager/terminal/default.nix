#
# OpenVPN
#
{ pkgs
, #
  ...
}: {
  # programs.alacritty = {
  #   enable = true;
  #   settings = {
  #     cursor = {
  #       style = "Block";
  #     };

  #     window = {
  #       opacity = 1.0;
  #       padding = {
  #         x = 24;
  #         y = 24;
  #       };
  #     };

  #     font = {
  #       normal = {
  #         family = "Iosevka";
  #         style = "Regular";
  #       };
  #       size = lib.mkMerge [
  #         (lib.mkIf pkgs.stdenv.hostPlatform.isLinux 10)
  #         (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin 14)
  #       ];
  #     };

  #     dynamic_padding = true;
  #     decorations = "full";
  #     title = "Terminal";
  #     class = {
  #       instance = "Alacritty";
  #       general = "Alacritty";
  #     };

  #     colors = {
  #       primary = {
  #         background = "0x1f2528";
  #         foreground = "0xc0c5ce";
  #       };

  #       normal = {
  #         black = "0x1f2528";
  #         red = "0xec5f67";
  #         green = "0x99c794";
  #         yellow = "0xfac863";
  #         blue = "0x6699cc";
  #         magenta = "0xc594c5";
  #         cyan = "0x5fb3b3";
  #         white = "0xc0c5ce";
  #       };

  #       bright = {
  #         black = "0x65737e";
  #         red = "0xec5f67";
  #         green = "0x99c794";
  #         yellow = "0xfac863";
  #         blue = "0x6699cc";
  #         magenta = "0xc594c5";
  #         cyan = "0x5fb3b3";
  #         white = "0xd8dee9";
  #       };
  #     };
  #   };
  # };
  # home.packages = [
  #   pkgs-unstable.kitty-themes
  # ];
  # programs.kitty = {
  #   enable = true;
  #   font = {
  #     name = "Iosevka";
  #     size = 16;
  #   };
  #   # theme = "Doom One Light";
  #   package = pkgs.kitty;
  #   settings = {
  #     remeber_window_size = true;
  #     initial_window_width = 640;
  #     initial_window_height = 400;
  #     enable_audio_bell = false;
  #     update_check_interval = 0;
  #   };
  #   environment = {LS_COLORS = "1";};
  # };
  programs.wezterm = {
    enable = true;
    extraConfig = let
        fontsize = if pkgs.stdenv.isDarwin then "14.0" else "13.0";
      in
      ''
        -- Pull in the wezterm API
        local wezterm = require 'wezterm'

        -- This table will hold the configuration.
        local config = {}

        -- In newer versions of wezterm, use the config_builder which will
        -- help provide clearer error messages
        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        wezterm.on('toggle-opacity', function(window, pane)
          local overrides = window:get_config_overrides() or {}
          if not overrides.window_background_opacity then
            overrides.window_background_opacity = 0.93
          else
            overrides.window_background_opacity = nil
          end
          window:set_config_overrides(overrides)
        end)

        wezterm.on('toggle-maximize', function(window, pane)
          window:maximize()
        end)

        -- This is where you actually apply your config choices
        config.color_scheme = "Catppuccin Mocha"
        config.font = wezterm.font("JetBrainsMono Nerd Font")
        config.hide_tab_bar_if_only_one_tab = true
        config.scrollback_lines = 10000
        config.enable_scroll_bar = true

        config.keys = {
          -- toggle opacity(CTRL + SHIFT + B)
          {
            key = 'B',
            mods = 'CTRL',
            action = wezterm.action.EmitEvent 'toggle-opacity',
          },
          {
            key = 'M',
            mods = 'CTRL',
            action = wezterm.action.EmitEvent 'toggle-maximize',
          },
        }

        config.font_size = ${fontsize}
      '' + (if pkgs.stdenv.isDarwin then ''
        -- Spawn a fish shell in login mod
        config.default_prog = { '/run/current-system/sw/bin/fish', '-l' }
      '' else "") + ''
        return config
      '';
  };
}
