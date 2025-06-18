{
  pkgs,
  flake,
  ...
}:
{
  imports = [
    # ./binds.nix
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
            ];
            substituters = [
              "https://nixpkgs-wayland.cachix.org"
            ];
          };

          # use it as an overlay
          nixpkgs.overlays = [ flake.inputs.nixpkgs-wayland.overlay ];

 # programs.niri = {
 #   enable = true;
 #   package = pkgs.niri-unstable;
 # };
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
