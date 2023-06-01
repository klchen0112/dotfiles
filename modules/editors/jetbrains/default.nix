#
# Neovim
#
{pkgs, ...}: {
  home.packages = with pkgs.jetbrains; [clion ];
}
