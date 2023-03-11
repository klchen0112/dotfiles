#
# OpenVPN
#
{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.google-chrome = {
    enable = true;
  };
}
