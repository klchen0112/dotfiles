{ inputs, ... }:
{
  flake-file.inputs = {
    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  den.aspects.noctalia-shell.nixos =
    { pkgs, ... }:
    {
      networking.networkmanager.enable = true;
      hardware.bluetooth.enable = true;
      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;
    };
  den.aspects.noctalia-shell.noctalia-shell =
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

          # ...
          binds = with config.lib.niri.actions; {
            "Mod+Space".action.spawn = [
              "noctalia"
              "msg"
              "panel-toggle"
              "launcher"
            ];
            "Mod+P".action.spawn = [
              "noctalia"
              "msg"
              "panel-toggle"
              "control-center"
            ];
            "Alt+Tab".action.spawn = [
              "noctalia"
              "msg"
              "window-switcher"
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
        inputs.noctalia-shell.overlays.default
      ];

      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        package = pkgs.noctalia;
      };
    };

}
