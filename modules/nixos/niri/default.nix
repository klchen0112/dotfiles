{
  pkgs,
  flake,
  ...
}:
{
  imports = [
    flake.inputs.niri.nixosModules.niri
  ];
  nixpkgs.overlays = [ flake.inputs.niri.overlays.niri ];
  # stylix.targets.niri.enable = true;
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;

}
