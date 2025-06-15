{
  pkgs,
  flake,
  ...
}:
{
  imports = [
    flake.inputs.niri.homeModules.stylix
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
  ];

  nix.settings = {
    substituters = [ "https://niri.cachix.org/" ];
  };
  nixpkgs.overlays = [ flake.inputs.niri.overlays.niri ];
  # Clipboard Manager not working
  stylix.targets.niri.enable = true;
  programs.niri.enable = pkgs.stdenv.isLinux;
  programs.niri.package = pkgs.niri-unstable;
  # make stuff work on wayland
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
