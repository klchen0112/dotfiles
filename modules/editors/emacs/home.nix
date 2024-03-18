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
    then pkgs.emacsPlus29
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
      ffmpegthumbnailer
      mediainfo
      # email
      # mu4e
      # spell check
      aspell

      # for emacs rime
      librime
    ]
    ++ (lib.optionals pkgs.stdenv.isDarwin) [
      # pngpaste for org mode download clip
      pngpaste
    ];

  home.file.".config/emacs/Rime" = {
    source = "${inputs.own-rime}";
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
    package = emacsPackage;
    client.enable = true;
    socketActivation.enable = true;
    startWithUserSession = "graphical";
    defaultEditor = true;
  };
}
