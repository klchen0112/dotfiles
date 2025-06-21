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
  ];
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
