{
  pkgs,
  config,
  flake,
  ...
}:
{
  stylix.autoEnable = false;
  stylix = {
    homeManagerIntegration.autoImport = false;
    homeManagerIntegration.followSystem = false;
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.machine.base16Scheme}.yaml";
    opacity = {
      applications = 0.8;
      terminal = 0.8;
    };
    fonts = {
      emoji = {
        package = pkgs.twemoji-color-font;
        name = "Twitter Color Emoji";
      };
      monospace = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
      };
      serif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "CMU Sans Serif";
      };
    };
  };
}
