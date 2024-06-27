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
  imports = [inputs.nix-doom-emacs-unstraightened.hmModule];

  home.file.".cache/doom/nix/rime" = {
    source = "${inputs.own-rime}";
    recursive = true;
  };

  programs.pandoc.enable = true;

  # home.file.".config/emacs".source = inputs.doomemacs;
  # home.file.".config/doom" = {
  # source = ./doom;
  # recursive = true;
  # onChange = "~/.config/emacs/bin/doom sync";
  # };

  # programs.emacs = {
  # enable = true;
  # package = emacsPackage;
  # };

  # doom-emacs will enable programs.emacs
  programs.doom-emacs = {
    enable = true;
    doomDir = ./doom;
    emacs = emacsPackage;
    extraBinPackages = with pkgs;
      [
        ripgrep
        fd
        tdlib
        curl
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

        libwebp
        tdlib
        pkg-config
      ]
      ++ (lib.optionals pkgs.stdenv.isDarwin) [
        # pngpaste for org mode download clip
        pngpaste
      ];
    extraPackages = epkgs:
      with epkgs; [
        vterm
        treesit-grammars.with-all-grammars
        rime
      ];
    provideEmacs = true;
  };
  services.emacs = {
    enable = pkgs.stdenv.isLinux;
    package = emacsPackage;
    client.enable = true;
    socketActivation.enable = true;
    startWithUserSession = "graphical";
    defaultEditor = true;
  };
}
