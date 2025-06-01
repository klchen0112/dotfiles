{
  flake,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;
  emacsPackage = pkgs.emacsIGC;
  # doomPath = "${config.home.homeDirectory}/my/dotfiles/modules/editors/emacs/doom";

  extraPackages =
    with pkgs;
    [
      ripgrep
      fd
      curl
      # org mode dot
      graphviz
      imagemagick
      # mpvi required
      tesseract5
      ffmpeg
      ffmpegthumbnailer
      mediainfo
      sqlite
      # email
      # mu4e
      # spell check
      hunspell
      languagetool

      pkg-config
      # telega
      libwebp

      #
      # texliveFull
      direnv
      # emacs-lsp-booster
      # ------------------- Python ---
      pyright
      ruff
      # poetry
      uv
      # ------------------- Web -------------------------
      nodejs
      typescript

      typescript-language-server
      emmet-ls
      jsonnet-language-server
      yaml-language-server
      # Building tools
      # bazel_7
      cmake

      dasel

      iosevka
      cm_unicode
      ibm-plex
      symbola
      noto-fonts-emoji
      liberation_ttf
      freefont_ttf
      twemoji-color-font
      TsangerJinKai02
      noto-fonts-cjk-sans
    ]
    ++ (lib.optionals pkgs.stdenv.isDarwin) [
      # pngpaste for org mode download clip
      pngpaste
      hugo
    ];
in
{
  imports = [
    inputs.nix-doom-emacs-unstraightened.hmModule
  ];
  # home.sessionVariables = {
  #   "EIDTOR" = "emacs";
  # };
  stylix.targets.emacs.enable = false;
  # xdg.configFile."doom".source = config.lib.file.mkOutOfStoreSymlink doomPath;
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
  home.packages = extraPackages;
  # doom-emacs will enable programs.emacs
  programs.doom-emacs = {
    enable = true;
    doomDir = inputs.doom-config;
    emacs = emacsPackage;
    tangleArgs = ".";
    extraBinPackages = extraPackages;
    extraPackages =
      epkgs: with epkgs; [
        vterm
        treesit-grammars.with-all-grammars
        # rime
        telega
        evil
        meow
      ];
    provideEmacs = true;
    experimentalFetchTree = true;
  };
  services.emacs = {
    enable = true;
    client.enable = true;
    socketActivation.enable = true;
    startWithUserSession = "graphical";
    defaultEditor = true;
  };
}
