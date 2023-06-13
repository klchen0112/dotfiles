#
# ../../browser
#
{pkgs, ...}: {
  programs.google-chrome = {
    enable =
      if pkgs.stdenv.isLinux
      then true
      else false;
    package = pkgs.google-chrome;
  };
  # home.packages = with pkgs; [tor];
}
