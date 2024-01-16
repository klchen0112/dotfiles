{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  ...
}: let
  emacsPackage =
    if pkgs.stdenv.hostPlatform.isDarwin
    then pkgs.emacs-plus
    else pkgs.emacs29-pgtk;
in {
  home.packages = with pkgs;
    [
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

      # for emacs rime
      librime
    ]
    ++ (lib.optionals pkgs.stdenv.isDarwin) [
      # pngpaste for org mode download clip
      pngpaste
    ];

  home.file.".config/emacs/Rime" = {
    source = "${inputs.rime-jd}";
    recursive = true;
  };
  
  programs.pandoc.enable = true;

  # home.file.".config/emacs".source = inputs.doomemacs;
  home.file.".config/doom" = {
    source = ./doom;
    recursive = true;
    # onChange = "~/.config/emacs/bin/doom sync";
  };

  programs.emacs = {
    enable = true;
    package = emacsPackage;
  };

  # doom-emacs will enable programs.emacs
  # programs.doom-emacs = {
  # enable = true;
  # doomPrivateDir = ./doom;
  # emacsPackage = pkgs.emacs29;
  # };
  services.emacs = {
    enable = pkgs.stdenv.isLinux;
    client.enable = true;
    socketActivation.enable = true;
    startWithUserSession = "graphical";
    defaultEditor = true;
  };
}
