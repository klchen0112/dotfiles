{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../editors/emacs/doom-emacs
    ../../shells/git
    ../../shells/fish
    ../../shells/zsh
    ../../shells/terminal
    ../../lang/cpp
    ../../lang/julia
    ../../lang/lua
    ../../lang/latex
    ../../lang/markdown
    ../../lang/nix
    ../../lang/nodejs
    ../../lang/python
  ];

  home = {
    username = "chenkailong";
    homeDirectory = "/Users/chenkailong";
    stateVersion = "22.11";
  };
}
