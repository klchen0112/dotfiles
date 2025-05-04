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
  improts = [
    ./zen-browser.nix
    ./chrome.nix
  ];



  home.packages = [ pkgs.nur.repos.rycee.mozilla-addons-to-nix ];

}
