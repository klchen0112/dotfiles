{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [
    exa
    bat
    tree
  ];
}
