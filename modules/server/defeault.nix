{ flake, ... }:
{
  imports = [
    flake.inputs.srvos.nixosModules.server
  ];
}
