{

  pkgs,
  config,
  ...
}:
let
  rimePath = "${config.home.homeDirectory}/my/dotfiles/modules/im/rime";
in
{
  home.file = {
    "Library/Rime" = {
      enable = true;
      source = config.lib.file.mkOutOfStoreSymlink rimePath;
    };
  };
}
