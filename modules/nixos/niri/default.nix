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

}
