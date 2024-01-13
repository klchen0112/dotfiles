{
  inputs,
  pkgs,
  lib,
  outputs,
  ...
}: {
  home.file.".config/emacs/Rime" = {
    source = "${inputs.rime-jd}";
    recursive = true;
  };
  i18n.inputMethod = {
    enabled =
      if pkgs.stdenv.isLinux
      then "fcitx5"
      else null;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-configtool
      fcitx5-gtk # gtk im module
    ];
  };
  home.file = {
    ".config/fcitx5/conf/classicui.conf".source = ./classicui.conf;
    ".local/share/fcitx5/themes".source = "${inputs.nur-ryan4yin.packages.${pkgs.system}.catppuccin-fcitx5}/src";
  };

  home.file.".local/share/fcitx5/rime" = {
    source = "${inputs.rime-jd}";
    recursive = true;
  };
}
