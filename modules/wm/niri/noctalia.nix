{
  flake-file.inputs = {
    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };
  };
  flake.modules.homeManager.noctalia-shell =
    {
      inputs,
      config,
      ...
    }:
    {
      imports = [
        inputs.noctalia-shell.homeManagerModules.default

      ];
      programs.noctalia-shell = {
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
