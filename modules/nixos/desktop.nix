{ flake, ... }:
{
  imports = [
    flake.inputs.srvos.nixosModules.desktop
    ./niri
  ];
}
