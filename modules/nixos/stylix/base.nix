{
  pkgs,
  config,
  flake,
  ...
}:
{
  stylix.autoEnable = false;
  stylix = {
    enable = true;
    opacity = {
      applications = 0.8;
      terminal = 0.8;
      popups = 0.8;
    };

    fonts = {
      sizes = {
        applications = 12;
        terminal = 12;
        desktop = 10;
        popups = 10;
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
        package = pkgs.ibm-plex;
        name = "IBM Plex Serif";
      };
    };
  };
}
