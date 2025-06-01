#
# OpenVPN
#
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sing-box
    ifstat-legacy
  ];
}
