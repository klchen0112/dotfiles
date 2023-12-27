#
# Jetbrains Toolbox
#
{pkgs, ...}: {
  home.packages = with pkgs.jetbrains; [
    # idea-ultimate
    clion
    # pycharm-professional
  ];
}
