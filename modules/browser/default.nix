#
# OpenVPN
#
{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.google-chrome = {
    enable = true;
    package = pkgs-unstable.google-chrome;
  };
}
