#
# OpenVPN
#
{
  inputs,
  pkgs,
  username,
  #
  ...
}: {
  programs.alacritty = {
    enable = false;
    settings = {
      import = ["${inputs.own-nur.packages.${pkgs.system}.catppuccin-alacritty}/catppuccin-latte.toml"];
      window = {
        opacity = 0.93;
        startup_mode = "Windowed";
        dynamic_title = true;
        option_as_alt = "Both";
        decorations = "buttonless";
        blur = true;
      };
      scrolling = {
        history = 10000;
      };
      font = {
        bold = {
          family = "JetBrainsMono Nerd Font";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
        };
        normal = {
          family = "JetBrainsMono Nerd Font";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font";
        };
        size = 14;
      };
      shell = {
        program = "${pkgs.fish}/bin/fish";
        args = ["-l"];
      };
      env = {
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
      };
      selection = {
        save_to_clipboard = true;
      };
    };
  };

  programs.kitty = {
    enable = true;

    environment = {
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };
    theme = "Catppuccin-Latte";
    shellIntegration = {
      enableFishIntegration = true;
    };
    settings = {
      #-------------------------------------------- Font --------------------------------------------
      font_family = "Iosevka";
      font_size = 13;

      #-------------------------------------------- Window --------------------------------------------
      hide_window_decorations =
        if pkgs.stdenv.isDarwin
        then "titlebar-only "
        else true;

      #-------------------------------------------- Mouse --------------------------------------------
      url_prefixes = "http https file ftp";
      copy_on_select = true;

      detect_urls = true;

      #-------------------------------------------- Shell --------------------------------------------
      shell =
        if pkgs.stdenv.isDarwin
        then "/etc/profiles/per-user/${username}/bin/fish --login --interactive"
        else "/etc/profiles/per-user/${username}/bin/fish";
      #-------------------------------------------- Macos Settings --------------------------------------------
      macos_titlebar_color = "system";
      macos_option_as_alt = false;
      macos_hide_from_tasks = false;
      macos_quit_when_last_window_closed = false;
      macos_window_resizable = true;
      macos_thicken_font = 0;
      macos_traditional_fullscreen = false;
      macos_show_window_title_in = "all";
    };
  };

  programs.wezterm = {
    enable = false;
    extraConfig = let
      fontsize =
        if pkgs.stdenv.isDarwin
        then "14.0"
        else "13.0";
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

        -- wezterm.gui is not available to the mux server, so take care to
        -- do something reasonable when this config is evaluated by the mux
        function get_appearance()
          if wezterm.gui then
            return wezterm.gui.get_appearance()
          end
          return 'Dark'
        end

        function scheme_for_appearance(appearance)
          if appearance:find 'Dark' then
            return 'Catppuccin Macchiato'
          else
            return 'Catppuccin Latte'
          end
        end
        config.color_scheme =  scheme_for_appearance(get_appearance())
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
      ''
      + (
        if pkgs.stdenv.isDarwin
        then ''
          -- Spawn a fish shell in login mod
          config.default_prog = { '/run/current-system/sw/bin/fish', '-l' }
        ''
        else ""
      )
      + ''
        return config
      '';
  };
}
