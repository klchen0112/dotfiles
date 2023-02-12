{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/editors/emacs/doom-emacs
    ../../modules/shells/fish
    ../../modules/shells/git
  ];

  home = {
    username = "chenkailong";
    homeDirectory = "/Users/chenkailong";
    stateVersion = "22.11";
  };

}
