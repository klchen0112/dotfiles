{

  pkgs,
  config,
  ...
}:
let
  rimePath = "${config.home.homeDirectory}/my/dotfiles/modules/im/rime";
in
{
  i18n.inputMethod = {
    enabled =  "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-configtool
      fcitx5-gtk # gtk im module
    ];
  };
  home.file = {
    ".config/fcitx5/conf/classicui.conf" = {
      enable = true;
      source = ./classicui.conf;
    };
    ".local/share/fcitx5/rime" = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink rimePath;
    };
  };
}
