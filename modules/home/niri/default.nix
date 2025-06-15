{
  pkgs,
  flake,
  ...
}:
{
  imports = [
    flake.inputs.niri.homeModules
    flake.inputs.niri.homeModules.config
    # flake.inputs.niri.homeModules.stylix
    # ./binds.nix
    #./hyprlock.nix
    # ./wine.nix
    #./anyrun.nix
    #./hypridle.nix
  ];
  home.packages = with pkgs; [
    # screenshot
    grim
    slurp

    # utils
    wl-clipboard
  ];
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  nix.settings = {
    substituters = [ "https://niri.cachix.org/" ];
  };
  # stylix.targets.niri.enable = true;
  # make stuff work on wayland
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
