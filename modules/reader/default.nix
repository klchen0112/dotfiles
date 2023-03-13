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
  programs.sioyek = {
    enable = true;
    package = pkgs-unstable.sioyek;
  };
}
