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
    inputs.stylix.darwinModules.stylix
  ];

}
