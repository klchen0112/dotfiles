{ flake, ... }:
{
  imports = [
    flake.inputs.srvos.nixosModules.desktop
    flake.inputs.srvos.nixosModules.server
    ./niri
  ];
  fonts.fontDir.enable = true;
}
