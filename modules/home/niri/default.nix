{
  pkgs,
  flake,
  ...
}:
{
  imports = [
    ./binds.nix
    ./hyprlock.nix
    ./wine.nix
    ./anyrun.nix
    ./hypridle.nix
  ];
  home.packages = with pkgs; [
    # screenshot
    grim
    slurp
    # utils
    wl-clipboard
    swaybg
    hyprlock
    swaylock-effects
    swayidle
    wlogout
    wlsunset
    fuzzel
    waybar
    uwsm
    xwayland-satellite
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
  nix.settings = {
    # add binary caches
    trusted-public-keys = [
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
    substituters = [
      "https://nixpkgs-wayland.cachix.org"
      "https://niri.cachix.org"
    ];
  };
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
