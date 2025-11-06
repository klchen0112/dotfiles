{
  flake.modules.homeManager.niri =
    {
      config,
      pkgs,
      ...
    }:
    {
      programs.niri.settings.binds = with config.lib.niri.actions; {
        "Print".action.screenshot-screen = {
          write-to-disk = true;
        };
#        "Mod+Shift+Alt+S".action = screenshot-window;
        "Mod+Q".action = close-window;
        "Mod+F".action = maximize-column;
        # "Mod+Shift+F".action = fullscreen-window;
        "Mod+Shift+F".action = expand-column-to-available-width;

        "Mod+Alt+F".action = toggle-window-floating;
        "Mod+W".action = toggle-column-tabbed-display;

        "Mod+1".action = focus-workspace 1; # nix: Mod+1 { focus-workspace 1; }
        "Mod+2".action = focus-workspace 2; # nix: Mod+2 { focus-workspace 2; }
        "Mod+3".action = focus-workspace 3; # nix: Mod+3 { focus-workspace 3; }
        "Mod+4".action = focus-workspace 4; # nix: Mod+4 { focus-workspace 4; }
        "Mod+5".action = focus-workspace 5; # nix: Mod+5 { focus-workspace 5; }
        "Mod+6".action = focus-workspace 6; # nix: Mod+6 { focus-workspace 6; }
        "Mod+7".action = focus-workspace 7; # nix: Mod+7 { focus-workspace 7; }
        "Mod+8".action = focus-workspace 8; # nix: Mod+8 { focus-workspace 8; }
        "Mod+9".action = focus-workspace 9; # nix: Mod+9 { focus-workspace 9; }
        "Mod+Ctrl+1".action = move-column-to-index 1; # nix: Mod+Ctrl+1 { move-column-to-workspace 1; }
        "Mod+Ctrl+2".action = move-column-to-index 2; # nix: Mod+Ctrl+2 { move-column-to-workspace 2; }
        "Mod+Ctrl+3".action = move-column-to-index 3; # nix: Mod+Ctrl+3 { move-column-to-workspace 3; }
        "Mod+Ctrl+4".action = move-column-to-index 4; # nix: Mod+Ctrl+4 { move-column-to-workspace 4; }
        "Mod+Ctrl+5".action = move-column-to-index 5; # nix: Mod+Ctrl+5 { move-column-to-workspace 5; }
        "Mod+Ctrl+6".action = move-column-to-index 6; # nix: Mod+Ctrl+6 { move-column-to-workspace 6; }
        "Mod+Ctrl+7".action = move-column-to-index 7; # nix: Mod+Ctrl+7 { move-column-to-workspace 7; }
        "Mod+Ctrl+8".action = move-column-to-index 8; # nix: Mod+Ctrl+8 { move-column-to-workspace 8; }
        "Mod+Ctrl+9".action = move-column-to-index 9; # nix: Mod+Ctrl+9 { move-column-to-workspace 9; }

        "Mod+I".action = consume-window-into-column;
        "Mod+O".action = expel-window-from-column;
        "Mod+C".action = center-visible-columns;
        "Mod+Tab".action = switch-focus-between-floating-and-tiling;

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        "Mod+H".action = focus-column-left;
        "Mod+S".action = focus-column-right;
        "Mod+T".action = focus-window-or-workspace-down;
        "Mod+D".action = focus-window-or-workspace-up;

        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Down".action = focus-workspace-down;
        "Mod+Up".action = focus-workspace-up;

        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+S".action = move-column-right;
        "Mod+Shift+D".action = move-column-to-workspace-up;
        "Mod+Shift+T".action = move-column-to-workspace-down;

        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Right".action = move-column-right;
        "Mod+Shift+Up".action = move-column-to-workspace-up;
        "Mod+Shift+Down".action = move-column-to-workspace-down;

        "Mod+Shift+Ctrl+T".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+D".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-up;

        "Mod+Shift+Slash".action = show-hotkey-overlay;
        "Mod+Alt+V".action = toggle-overview;
        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;
        "Mod+R".action = switch-preset-column-width;

      };

    };
}
