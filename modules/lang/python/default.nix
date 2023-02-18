
{ config, lib, pkgs, ... }:

{


  home.packages = with pkgs;
  [
    python310
    python310Packages.pip
    python310Packages.isort
    
    nodejs
    nodePackages.pyright
  ];
}
