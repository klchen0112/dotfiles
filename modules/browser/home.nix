#
# ../../browser
#
{
  pkgs,
  lib,
  inputs,
  isWork,
  ...
}:
{
  imports = [
    ./zen.nix
    ./chrome.nix
  ];


  home.packages = [ pkgs.nur.repos.rycee.mozilla-addons-to-nix ];

}
