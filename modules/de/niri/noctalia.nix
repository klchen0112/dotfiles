{ inputs, ... }:
{
  flake-file.inputs = {
    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  flake.modules.nixos.noctalia-shell =
    { pkgs, ... }:
    {
      networking.networkmanager.enable = true;
      hardware.bluetooth.enable = true;
      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;
    };
  flake.modules.homeManager.noctalia-shell =
    {
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.noctalia-shell.homeModules.default

      ];

      programs.niri = {
        settings = {

          spawn-at-startup = [
            { command = [ "noctalia-shell" ]; }
          ];

          # ...
          binds = with config.lib.niri.actions; {
            "Mod+Space".action.spawn = [
              "noctalia-shell"
              "ipc"
              "call"
              "launcher"
              "toggle" # ✅

            ];
            "Mod+P".action.spawn = [
              "noctalia-shell"
              "ipc"
              "call"
              "sessionMenu"
              "toggle" # ❌
            ];
          };
        };
      };
      #      home.file.".cache/noctalia/wallpapers.json" = {
      #        text = builtins.toJSON {
      #          defaultWallpaper = "${config.home.homeDirectory}/Pictures/Wallpapers/default.png";
      #          wallpapers = {
      #            "DP-1" = "${config.home.homeDirectory}/Pictures/Wallpapers/default.png";
      #          };
      #        };
      #      };
      nixpkgs.overlays = [
        inputs.noctalia-shell.inputs.noctalia-qs.overlays.default
        inputs.noctalia-shell.overlays.default
      ];

      programs.noctalia-shell = {
        enable = true;
        package = pkgs.noctalia-shell;
      };
    };

}
