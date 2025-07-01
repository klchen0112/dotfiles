{
  pkgs,
  config,
  flake,
  ...
}:
{
  imports = [
    flake.inputs.stylix.homeModules.stylix
  ];
  stylix.autoEnable = false;
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.me.base16Scheme}.yaml";
    opacity = {
      applications = 0.8;
      terminal = 0.8;
    };
    fonts = {
      sizes = {
        terminal = 14;
        applications= 16;
        popups = 12;
      };
      emoji = {
        package = pkgs.twemoji-color-font;
        name = "Twitter Color Emoji";
      };
      monospace = {
        package = pkgs.nur.repos.skiletro.mplus;
        name = "M PLUS Code Latin 50";
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
