{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../editors/emacs/doom-emacs
    ../../lang/cpp
    ../../lang/julia
    ../../lang/lua
    ../../lang/latex
    ../../lang/markdown
    ../../lang/nix
    ../../lang/nodejs
    ../../lang/python
    ../../shells/git
    ../../shells/fish
    ../../shells/zsh
    ../../shells/terminal
    ../../vpn
  ];

  home = {
    username = "chenkailong";
    homeDirectory = "/Users/chenkailong";
    stateVersion = "22.11";
  };
}
