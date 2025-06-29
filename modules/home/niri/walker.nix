{ pkgs, flake, ... }:
{
  imports = [ flake.inputs.walker.homeManagerModules.default ];
  programs.walker = {

  };
}
