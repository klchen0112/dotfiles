#
# OpenVPN
#
{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.sioyek = {
    enable = true;
  };
}
