{
  flake-file.inputs = {
    quickshell = {
      # url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      follows = "niri-caelestia-shell/quickshell";
    };
    niri-caelestia-shell = {
      url = "github:jutraim/niri-caelestia-shell";
      inputs.nixpkgs.follows = "nixpkgs";

    };
  };
  flake.modules.homeManager.niri-caelestia-shell =
    {
      inputs,
      config,
      ...
    }:
    {
      imports = [
        inputs.niri-caelestia-shell.homeManagerModules.default

      ];
      home.packages = [
        config.programs.caelestia.cli.package
      ];
      programs.caelestia = {
        enable = true;
        cli = {

          enable = true;
          settings.theme = {
            enableBtop = true;
            enableCava = true;
            enableGtk = true;
            enableQt = true;

          };

        };
        systemd = {
          enable = true;
        };
        settings = {
          bar.status = {
            showBattery = false;
          };
          appearance.font.family = {
            mono = config.stylix.fonts.monospace.name;
          };
        };
      };
      programs.fuzzel = {
        enable = true;
      };

      programs.niri.settings.binds = with config.lib.niri.actions; {
        "Mod+Space" = {
          action = spawn "caelestia-shell" "ipc" "call" "drawers" "toggle" "launcher";
          hotkey-overlay.title = "Toggle Application Launcher";
        };
        "Mod+L".action = spawn "caelestia-shell" "ipc" "call" "lock" "lock";
	"Mod+V".action = spawn "pkill" "fuzzel" "||" "caelestia" "clipboard";
      };
    };
}
