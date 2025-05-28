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
    # inputs.stylix.homeManagerModules.stylix
  ];
  stylix.targets.gnome.enable = pkgs.stdenv.isLinux;

}
