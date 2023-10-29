#
# OpenVPN
#
{ inputs
, pkgs
, #
  ...
}: {

  xdg.configFile."alacritty/theme_catppuccin.yml".source = "${inputs.catppuccin-alacritty}/catppuccin-mocha.yml";
  programs.alacritty = {
    enable = true;
  };
  xdg.configFile."alacritty/alacritty.yml".text =
    ''
      import:
        # all alacritty themes can be found at
        #    https://github.com/alacritty/alacritty-theme
        - ~/.config/alacritty/theme_catppuccin.yml

      window:
        # Background opacity
        #
        # Window opacity as a floating point number from `0.0` to `1.0`.
        # The value `0.0` is completely transparent and `1.0` is opaque.
        opacity: 0.93

        # Startup Mode (changes require restart)
        #
        # Values for `startup_mode`:
        #   - Windowed
        #   - Maximized
        #   - Fullscreen
        #
        # Values for `startup_mode` (macOS only):
        #   - SimpleFullscreen
        startup_mode: Maximized

        # Allow terminal applications to change Alacritty's window title.
        dynamic_title: true

        # Make `Option` key behave as `Alt` (macOS only):
        #   - OnlyLeft
        #   - OnlyRight
        #   - Both
        #   - None (default)
        option_as_alt: Both

      scrolling:
        # Maximum number of lines in the scrollback buffer.
        # Specifying '0' will disable scrolling.
        history: 10000

        # Scrolling distance multiplier.
        #multiplier: 3

      # Font configuration
      font:
        # Normal (roman) font face
        bold:
          family: JetBrainsMono Nerd Font
        italic:
          family: JetBrainsMono Nerd Font
        normal:
          family: JetBrainsMono Nerd Font
        bold_italic:
          # Font family
          #
          # If the bold italic family is not specified, it will fall back to the
          # value specified for the normal font.
          family: JetBrainsMono Nerd Font
    ''
    + (
      if pkgs.stdenv.isDarwin
      then ''
          # Point size
          size: 14
        shell:  # force nushell as default shell on macOS
          program:  /run/current-system/sw/bin/nu
      ''
      else ''
        # holder identation
          # Point size
          size: 13
      ''
    );

  programs.wezterm = {
    enable = true;
    extraConfig =
      let
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
      '' + (if pkgs.stdenv.isDarwin then ''
        -- Spawn a fish shell in login mod
        config.default_prog = { '/run/current-system/sw/bin/fish', '-l' }
      '' else "") + ''
        return config
      '';
  };
}
