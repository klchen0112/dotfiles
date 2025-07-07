{
  pkgs,
  config,
  ...
}:
{
  stylix.targets.ghostty.enable = true;
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.brewCasks.ghostty else pkgs.ghostty;
    installBatSyntax = true;
    settings = {
      window-colorspace = if pkgs.stdenv.isDarwin then "display-p3" else "srgb";
      macos-titlebar-style = "hidden";
    };
  };

}
