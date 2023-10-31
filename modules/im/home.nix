{ inputs, pkgs, ... }:
{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs;
      [
        fcitx5-rime
        fcitx5-configtool
        fcitx5-gtk # gtk im module
      ];
  };
  home.file = {
    ".config/fcitx5/conf/classicui.conf".source = ./classicui.conf;
    ".local/share/fcitx5/themes".source = "${inputs.catppuccin-fcitx5}/src";
  };

  home.file.".local/share/fcitx5/rime" = {
    source = "${inputs.rime-jd}";
    recursive = true;
  };
}
