{
  pkgs,
  flake,
  lib,
  ...
}:
{
  imports = [
    # ./binds.nix
    # ./wine.nix
    # ./walker
    # ./settings.nix
    # ./swayidle.nix
    # ./swaylock.nix
    # ./swaync.nix
    # ./waybar
    # ./xwayland-satellite.nix
    # ./services.nix
    flake.inputs.niri-caelestia-shell.homeManagerModules.default
  ];
  programs.caelestia = {
    enable = true;
    cli.enable = true;
  };
  programs.fuzzel = {
    enable = true;
  };
  home.packages = with pkgs; [
    # screenshot
    grim
    slurp
    # utils
    wl-clipboard
    wlr-randr
    gnome-themes-extra

  ];

  # 夜光护眼软件
  services.wlsunset = {
    enable = true;
    latitude = "30:00";
    longitude = "120:00";
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
