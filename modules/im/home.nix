{
  inputs,
  pkgs,
  lib,
  outputs,
  ...
}: {
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
    ".config/fcitx5/conf/classicui.conf" = {
      enable = pkgs.stdenv.isLinux;
      source = ./classicui.conf;
    };
    ".local/share/fcitx5/themes" = {
      enable = pkgs.stdenv.isLinux;
      source = "${inputs.own-nur.packages.${pkgs.system}.catppuccin-fcitx5}/src";
    };
    # ".local/share/fcitx5/rime" = {
    #   enable = pkgs.stdenv.isLinux;
    #   source = "${inputs.own-rime}";
    #   recursive = true;
    #   # overwrite = true;
    # };

    # "Library/Rime" = {
    #   enable = false; # pkgs.stdenv.isDarwin
    #   source = "${inputs.own-rime}";
    #   recursive = true;
    #   # overwrite = true;
    # };
  };
}
