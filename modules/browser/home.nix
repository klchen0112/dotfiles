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
  programs.google-chrome = {
    enable = false;
    package = pkgs.google-chrome;
  };

  #   };
  # };
  home.packages = [ pkgs.nur.repos.rycee.mozilla-addons-to-nix ];

}
