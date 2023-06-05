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
{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # python/default.nix install python
    ripgrep
    fd
    curl
    sqlite
    # emacsGit

    # for emacs sqlite
    gcc
    # org mode dot
    graphviz
    imagemagick

    pandoc

    # fonts
    material-design-icons
    weather-icons
    emacs-all-the-icons-fonts

    # mpvi required
    mpv
    yt-dlp
    tesseract5
    ffmpeg_5
  ];
  programs.emacs = {
    enable = true;
    package = pkgs.emacsGit;
  };
}
