{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  isWork,
  ...
}:
{
  stylix = {

    enable = true;
    image =
      if pkgs.stdenv.isDarwin then "/Users/${username}/desktop.img" else "/user/${username}/desktop.img";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
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

    };
  };
}
