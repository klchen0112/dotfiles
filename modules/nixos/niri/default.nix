{
  pkgs,
  flake,
  ...
}:
{
  imports = [
    flake.inputs.niri.nixosModules.niri
  ];
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;
  nixpkgs.overlays = [ flake.inputs.niri.overlays.niri ];
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
}
