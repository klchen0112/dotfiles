{ inputs, pkgs, lib, config, ... }:
{

  imports = [
    inputs.anyrun.homeManagerModules.default
  ];

  programs.anyrun = {
    enable = true;
  };
}
