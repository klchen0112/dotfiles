{ config, lib, pkgs, ... }:

{
  imports = [
    ../../editors/emacs/doom-emacs
    ../../shells/git
    ../../shells/fish
    ../../shells/zsh
    ../../shells/terminal
    ../../lang/python
    ../../lang/julia
    ../../lang/markdown
  ];

  home = {
    username = "chenkailong";
    homeDirectory = "/Users/chenkailong";
    stateVersion = "22.11";
  };

}
