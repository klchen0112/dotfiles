{ inputs, ... }:
{
  flake-file.inputs = {
    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  # 桌面环境的基础服务：只有跑桌面环境的 host 才需要，所以不再默认给所有 nixos。
  # 由 `den.aspects.niri` include（见 modules/de/niri/default.nix）；不用 niri 的 host
  # 想要蓝牙/upower 时可以单独 include `<desktop>`。
  den.aspects.desktop.nixos = {
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
            "Mod+V".action.spawn = [
              "noctalia"
              "msg"
              "panel-toggle"
              "clipboard"
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

      programs.noctalia = {
        enable = true;
        systemd.enable = true;
      };
    };

}
