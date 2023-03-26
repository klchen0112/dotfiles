#
# OpenVPN
#
{pkgs, ...}: {
  programs.google-chrome = {
    enable = true;
    package = pkgs.google-chrome;
  };
}
