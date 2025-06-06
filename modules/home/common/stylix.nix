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
