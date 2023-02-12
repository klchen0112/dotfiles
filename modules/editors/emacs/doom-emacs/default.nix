#
# Doom Emacs: Personally not a fan of github:nix-community/nix-doom-emacs due to performance issues
# This is an ideal way to install on a vanilla NixOS installion.
# You will need to import this from somewhere in the flake (Obviously not in a home-manager nix file)
#
# flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   ├─ ./darwin
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./editors
#           └─ ./emacs
#               └─ ./doom-emacs

#


{ config,lib, pkgs,pkgs-unstable,inputs, ... }:

{

  home.packages = with pkgs; [
    python3 # treemacs
    ripgrep
    fd
    curl
    emacs29

    # for emacs sqlite
    gcc

    nodejs
    # Typescript
    nodePackages.typescript
    nodePackages.typescript-language-server

    pkgs-unstable.terraform-ls

    tree-sitter
  ];
}
