{
  pkgs,
  ...
}:
{
  programs.ghostty = {
    enable = pkgs.stdenv.isLinux;
  };

}
