{ config, lib, pkgs, ... }:

{
  imports = [
    ../../editors/emacs/doom-emacs
    ../../shells/git
    ../../shells/fish
    ../../shells/zsh
    ../../shells/terminal
    ../../lang/julia
    ../../lang/lua
    ../../lang/markdown
    ../../lang/python

  ];

  home = {
    username = "chenkailong";
    homeDirectory = "/Users/chenkailong";
    stateVersion = "22.11";
  };

}
