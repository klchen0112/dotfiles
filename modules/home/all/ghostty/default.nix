#
# OpenVPN
#
{ inputs
, pkgs
, lib
, username
, config
, #
  ...
}:
{
  programs.ghostty = {
    enable = true;
  };
}
