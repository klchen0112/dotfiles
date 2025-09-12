let
  cfg =
    {
      pkgs,
      ...
    }:
    {
      stylix.autoEnable = false;
      stylix = {
        enable = true;
        opacity = {
          applications = 0.9;
          terminal = 0.9;
          popups = 0.9;
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
            package = pkgs.nerd-fonts."m+";
            name = "M+CodeLat50 Nerd Font";
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
    };
in
{
  flake.modules.homeManager.stylix = cfg;
  flake.modules.darwin.stylix = cfg;
  flake.modules.linux.stylix = cfg;

}
