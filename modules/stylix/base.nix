let
  cfg =
    {
      pkgs,
      ...
    }:
    {
      stylix.autoEnable = true;
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
            desktop = 9;
            popups = 9;
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
  den.aspects.stylix-home.stylix-home = cfg;
  den.aspects.stylix.darwin = cfg;
  den.aspects.stylix.nixos = cfg;
}
