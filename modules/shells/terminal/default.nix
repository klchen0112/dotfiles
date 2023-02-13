{ config, lib, pkgs, ... }:

{

  home.packages = with pkgs; [
    exa
    bat
    tree
    starship
  ];
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
}
