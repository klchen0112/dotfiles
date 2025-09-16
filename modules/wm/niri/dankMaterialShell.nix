{
  flake-file.inputs = {
    DankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  flake.modules.homeManager.niri =
    {
      inputs,
      config,
      ...

    }:
    {

      imports = [
        inputs.DankMaterialShell.homeModules.dankMaterialShell
      ];
      programs.dankMaterialShell = {
        enable = true;
        enableKeybinds = true;
        enableSystemd = true;
        enableSpawn = false;
      };
      programs.niri.settings.binds = with config.lib.niri.actions; {
        "Print".action.screenshot-screen = {
          write-to-disk = true;
        };
        "Mod+Shift+Alt+S".action = screenshot-window;
        "Mod+Q".action = close-window;
        "Mod+F".action = maximize-column;
        # "Mod+Shift+F".action = fullscreen-window;
        "Mod+Shift+F".action = expand-column-to-available-width;

        "Mod+Alt+F".action = toggle-window-floating;
        "Mod+W".action = toggle-column-tabbed-display;

        "Mod+1".action = set-column-width "25%";
        "Mod+2".action = set-column-width "50%";
        "Mod+3".action = set-column-width "75%";
        "Mod+4".action = set-column-width "100%";

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
