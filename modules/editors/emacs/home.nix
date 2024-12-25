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
    then pkgs.emacsPlusMaster
    else pkgs.emacs29-pgtk;
in {
  imports = [
    inputs.nix-doom-emacs-unstraightened.hmModule
  ];

  # home.file.".cache/doom/nix/rime" = {
  #   source = "${inputs.own-rime}";
  #   recursive = true;
  # };

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
    doomDir = inputs.doom;
    emacs = emacsPackage;
    extraBinPackages = with pkgs;
      [
        ripgrep
        fd
        curl
        # for emacs sqlite
        gcc
        # org mode dot
        graphviz
        imagemagick
        # mpvi required
        tesseract5
        ffmpeg
        ffmpegthumbnailer
        mediainfo
        # email
        # mu4e
        # spell check
        aspell

        pkg-config
        # telega
        libwebp

        pandoc
        #
        texliveFull
        direnv
        devenv
        devbox
        # ------------------- Python ---
        pyright
        # poetry
        # ------------------- Web -------------------------
        nodejs
        typescript

        typescript-language-server
        emmet-ls
        jsonnet-language-server
      ]
      ++ (lib.optionals pkgs.stdenv.isDarwin) [
        # pngpaste for org mode download clip
        pngpaste
      ];
    extraPackages = epkgs:
      with epkgs; [
        # vterm
        treesit-grammars.with-all-grammars
        # rime
        telega
        # evil
        meow
      ];
    provideEmacs = true;
    experimentalFetchTree = true;
  };
  services.emacs = {
    enable = pkgs.stdenv.isLinux;
    client.enable = true;
    socketActivation.enable = true;
    startWithUserSession = "graphical";
    defaultEditor = true;
  };
}
