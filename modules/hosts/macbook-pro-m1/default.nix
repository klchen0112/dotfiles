{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    #  ../../browser
    ../../editors/emacs
    # ../../editors/nvim
    ../../editors/vscode
    ../../lang/cpp
    ../../lang/julia
    ../../lang/lua
    ../../lang/latex
    ../../lang/markdown
    ../../lang/nix
    ../../lang/nodejs
    ../../lang/python
    ../../reader
    ../../shells/git
    ../../shells/fish
    ../../shells/zsh
    ../../shells/shell
    ../../terminal
    ../../vpn
  ];

  home = {
    username = "chenkailong";
    homeDirectory = "/Users/chenkailong";
    stateVersion = "22.11";
  };
}
