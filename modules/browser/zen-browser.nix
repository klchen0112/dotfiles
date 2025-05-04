{
  pkgs,
  lib,
  inputs,
  isWork,
  ...
}:
{
  programs.google-chrome = {
    enable = true;
    package = pkgs.google-chrome;
  };
}
