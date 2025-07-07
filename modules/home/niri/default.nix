{
  pkgs,
  flake,
  lib,
  ...
}:
{
  imports = [
    ./binds.nix
    ./wine.nix
    ./walker
    ./settings.nix
    ./swayidle.nix
    ./swaylock.nix
    ./swaync.nix
    ./waybar
    ./xwayland-satellite.nix
  ];
  home.packages = with pkgs; [
    # screenshot
    grim
    slurp
    # utils
    wl-clipboard
    wlr-randr
    swaybg
    adwaita-icon-theme
    gnome-themes-extra
  ];
  # 调整亮度音量显示
  services.avizo.enable = true;

  # 通知显示
  services.swaync.enable = true;

  # 根据不同的设备加载不同的显示器分辨率刷新率缩放
  # 就不用去 wm 里面一个一个配，导致每次换设备都要重写配置
  # https://wiki.archlinux.org/title/Kanshi
  services.kanshi.enable = true;

  # 夜光护眼软件
  services.wlsunset = {
    enable = true;
    latitude = "30:00";
    longitude = "120:00";
  };
  # OSD for volume, brightness changes
  services.swayosd.enable = true;
  systemd.user.services.swayosd = {
    # Adjust swayosd restart policy - it's failing due to too many restart
    # attempts when resuming from sleep
    Unit.StartLimitIntervalSec = lib.mkForce 1;
  };
  nix.settings = {
    # add binary caches
    trusted-public-keys = [
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
    substituters = [
      "https://niri.cachix.org"
    ];
  };
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
