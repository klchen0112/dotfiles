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
{ inputs
, config
, lib
, pkgs
, username
, ...
}:
{
  home.packages = with pkgs; [
    fd
    curl
    sqlite

    # for emacs sqlite
    gcc
    # org mode dot
    graphviz
    imagemagick


    # mpvi required
    tesseract5
    ffmpeg_5
    # email
    # mu4e
  ] ++ (lib.optionals pkgs.stdenv.isDarwin) [
    # pngpaste for org mode download clip
    pngpaste
  ];

  programs.pandoc.enable = true;

  # home.file.".config/emacs".source = inputs.doomemacs;
  home.file.".config/doom" = {
    source = ./doom;
    recursive = true;
    # onChange = "~/.config/emacs/bin/doom sync";
  };


  programs.emacs = {
    enable = true;
    package =
      if pkgs.stdenv.hostPlatform.isDarwin then
        pkgs.emacs-plus
      else
        pkgs.emacs29;
  };
  # doom-emacs will enable programs.emacs
  # programs.doom-emacs = {
  # enable = true;
  # doomPrivateDir = ./doom;
  # emacsPackage = pkgs.emacs29;
  # };
}
