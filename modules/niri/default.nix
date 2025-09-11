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
    ./dankMaterialShell.nix
    # ./caelestia.nix
  ];
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
  # services.wlsunset = {
  #   enable = true;
  #   latitude = "30:00";
  #   longitude = "120:00";
  # };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    # for hyprland with nvidia gpu" = " ref https://wiki.hyprland.org/Nvidia/
    "LIBVA_DRIVER_NAME" = "nvidia";
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
    # VA-API hardware video acceleration
    "NVD_BACKEND" = "direct";

    "GBM_BACKEND" = "nvidia-drm";

  };
}
