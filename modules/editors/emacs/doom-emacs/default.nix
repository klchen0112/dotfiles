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


{ config, lib, pkgs, pkgs-unstable, inputs, ... }:

{

  home.packages = with pkgs; [
    python3 # treemacs
    ripgrep
    fd
    curl
    coreutils
    sqlite
    emacsGit

    fontconfig
    # for emacs sqlite
    gcc
    # org mode dot
    graphviz


    # fonts
    material-design-icons
    weather-icons
    emacs-all-the-icons-fonts
  ];
}
