{ flake, ... }:
{
  imports = [
    flake.inputs.srvos.nixosModules.desktop
    ./niri
  ];
  fonts.fontDir.enable = true;
}
