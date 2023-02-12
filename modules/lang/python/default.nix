
{ config, lib, pkgs, ... }:

{


  home.packages = with pkgs;
  [
    python39
    python39Packages.pip

    nodejs
    nodePackages.pyright
  ];
}
