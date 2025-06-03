{ flake, ... }:
{
  imports = [
    flake.inputs.srvos.darwinModules.desktop
  ];
}
