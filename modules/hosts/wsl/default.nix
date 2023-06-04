{pkgs, user,...}: {
  imports = [
    #  ../../browser
    ../../editors/emacs
    # ../../editors/nvim
    # ../../editors/vscode
    # ../../lang/cpp
    # ../../lang/julia
    # ../../lang/lua
    ../../lang/latex
    ../../lang/markdown
    ../../lang/nix
    # ../../lang/nodejs
    # ../../lang/python
    # ../../reader
    ../../shells/git
    ../../shells/fish
    # ../../shells/zsh
    ../../shells/shell
    ../../terminal
    # ../../vpn
  ];

  home = {
    username = "${user}";
    homeDirectory = "/Users/${user}";
    stateVersion = "23.05";
  };
}
