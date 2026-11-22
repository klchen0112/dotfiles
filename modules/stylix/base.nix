let
  # https://github.com/kiennq/modus-zenburn/blob/main/modus-zenburn.el
  dark = {
    name = "Modus Zenburn";
    variant = "dark";
    author = "Kien Nguyen";
    base00 = "3f3f3f"; # bg-main
    base01 = "383838"; # bg-dim
    base02 = "2b2b2b"; # bg-region
    base03 = "989890"; # fg-dim
    base04 = "d0bf8f"; # fg-line-number-active
    base05 = "dcdccc"; # fg-main
    base06 = "bfebbf"; # green-warmer
    base07 = "ffffef"; # cursor
    base08 = "ecb3b3"; # red
    base09 = "f3cd98"; # yellow-warmer
    base0A = "f0dfaf"; # yellow
    base0B = "a0c5a0"; # green
    base0C = "93e0e3"; # cyan
    base0D = "ace0e3"; # blue
    base0E = "e5aad2"; # magenta
    base0F = "dca3a3"; # red-warmer
  };
  light = {
    name = "Modus Zenburn Light";
    variant = "light";
    author = "Kien Nguyen";
    base00 = "f9f8f5"; # bg-main
    base01 = "efeee8"; # bg-dim
    base02 = "e4e2d8"; # bg-region
    base03 = "6f6f6f"; # fg-dim
    base04 = "656555"; # fg-alt
    base05 = "3e3e3e"; # fg-main
    base06 = "2c4454"; # blue-faint
    base07 = "402121"; # red-intense
    base08 = "7c4343"; # red
    base09 = "74421f"; # yellow-warmer
    base0A = "594600"; # yellow
    base0B = "365536"; # green
    base0C = "315858"; # cyan
    base0D = "2f4b5e"; # blue
    base0E = "663a57"; # magenta
    base0F = "653434"; # red-faint
  };
  cfg =
    scheme:
    {
      pkgs,
      lib,
      ...
    }:
    {
      stylix = {
        enable = true;
        base16Scheme = lib.mkDefault scheme;
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
  den.aspects.stylix-home.stylix-home = cfg dark;
  den.aspects.stylix.darwin = cfg light;
  den.aspects.stylix.nixos = cfg light;
}
