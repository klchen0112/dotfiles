
{ config, lib, pkgs, ... }:

{


  home.packages = with pkgs;
  [
    python310
    python310Packages.pip

    nodejs
    nodePackages.pyright
  ];
}
