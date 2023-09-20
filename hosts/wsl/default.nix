{ inputs
, lib
, config
, pkgs
, username
, ...
}: {
  imports = [
    # inputs.nix-doom-emacs.hmModule

    ../../home-manager/browser
    ../../home-manager/downloader
    # ../../home-manager/editors/codeblocks
    ../../home-manager/editors/jetbrains
    ../../home-manager/editors/emacs/default.nix
    # ../../home-manager/editors/vim
    # ../../home-manager/editors/nvim
    ../../home-manager/editors/vscode
    ../../home-manager/graphics
    ../../home-manager/keyboard
    ../../home-manager/lang/cpp
    ../../home-manager/lang/go
    ../../home-manager/lang/json
    ../../home-manager/lang/julia
    ../../home-manager/lang/lua
    ../../home-manager/lang/latex
    ../../home-manager/lang/markdown
    ../../home-manager/lang/nix
    ../../home-manager/lang/nodejs
    ../../home-manager/lang/python
    ../../home-manager/lang/rust
    ../../home-manager/media
    ../../home-manager/network
    ../../home-manager/notes
    ../../home-manager/office
    ../../home-manager/shells
    ../../home-manager/socialMedia
    ../../home-manager/terminal
    ../../home-manager/vm
    # ../../home-manager/vpn
  ];


  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };
  home.stateVersion = "23.11";

}
