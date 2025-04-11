{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  ...
}:
let
  emacsPackage = if pkgs.stdenv.hostPlatform.isDarwin then  pkgs.emacsIGC else pkgs.emacs-pgtk;
  doomPath = "${config.home.homeDirectory}/my/dotfiles/modules/editors/emacs/doom";

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
      # email
      # mu4e
      # spell check
      hunspell
      languagetool

      pkg-config
      # telega
      libwebp

      #
      texliveFull
      direnv
      devbox
      emacs-lsp-booster
      # ------------------- Python ---
      pyright
      ruff
      poetry
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
    ]
    ++ (lib.optionals pkgs.stdenv.isDarwin) [
      # pngpaste for org mode download clip
      pngpaste
    ];
in
{
  # imports = [
  #   inputs.nix-doom-emacs-unstraightened.hmModule
  # ];

  stylix.targets.emacs.enable = true;
  xdg.configFile."doom".source = config.lib.file.mkOutOfStoreSymlink doomPath;
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

  programs.emacs = {
    enable = true;
    package = emacsPackage;
  };
  home.packages = extraPackages;
  # doom-emacs will enable programs.emacs
  # programs.doom-emacs = {
  #   enable = true;
  #   doomDir = inputs.doom-config;
  #   emacs = emacsPackage;
  #   tangleArgs = ".";
  #   extraBinPackages = extraPackages;
  #   extraPackages = epkgs:
  #     with epkgs; [
  #       # vterm
  #       treesit-grammars.with-all-grammars
  #       # rime
  #       telega
  #       # evil
  #       meow
  #     ];
  #   provideEmacs = true;
  #   experimentalFetchTree = true;
  # };
  services.emacs = {
    enable = true;
    package = emacsPackage;
    client.enable = true;
    socketActivation.enable = true;
    startWithUserSession = "graphical";
    defaultEditor = true;
  };
}
