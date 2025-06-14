{
  pkgs,
  flake,
  ...
}:
{
  imports = [
    flake.inputs.niri.homeModules.stylix
    ./binds.nix
  ];
  nix.settings = {
    substituters = [ "https://niri.cachix.org/" ];
  };
  nixpkgs.overlays = [ flake.inputs.niri.overlays.niri ];
  # Clipboard Manager not working
  stylix.targets.niri.enable = true;
  programs.niri.enable = pkgs.stdenv.isLinux;
  programs.niri.package = pkgs.niri-unstable;

}
