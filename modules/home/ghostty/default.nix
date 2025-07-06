{
  pkgs,
  ...
}:
{
  stylix.targets.ghostty.enable = true;
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.brewCasks.ghostty else pkgs.ghostty;
    installBatSyntax = true;
  };

}
