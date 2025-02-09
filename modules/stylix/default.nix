{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  isWork,
  ...
}:
{
  imports = [
    ./base.nix
    inputs.stylix.nixosModules.stylix
  ];

}
