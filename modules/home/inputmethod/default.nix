{
  pkgs,
  config,
  ...
}:
let
  rimePath = "${config.home.homeDirectory}/my/dotfiles/rime";
in
{
  i18n.inputMethod = {
    enable = pkgs.stdenv.isLinux;
    type = "fcitx5";
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
    ".local/share/fcitx5/rime" = {
      enable = pkgs.stdenv.isLinux;
      source = config.lib.file.mkOutOfStoreSymlink rimePath;
    };

    "Library/Rime" = {
      enable = pkgs.stdenv.isDarwin;
      source = config.lib.file.mkOutOfStoreSymlink rimePath;
    };

  };
}
