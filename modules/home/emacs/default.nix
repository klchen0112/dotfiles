{
  flake,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;
  emacsPackage =
    if pkgs.stdenv.isDarwin then pkgs.emacsIGC else inputs.emacs-overlay.packages.${pkgs.system}.emacs-igc-pgtk;
  # doomPath = "${config.home.homeDirectory}/my/dotfiles/modules/editors/emacs/doom";

  extraPackages =
    with pkgs;
    [
      fd
      curl
      # org mode dot
      graphviz
      imagemagick
      # mpvi required
      tesseract5
      ffmpeg
      poppler
      ffmpegthumbnailer
      mediainfo
      sqlite
      # email
      # mu4e
      # spell check
      hunspell
      languagetool
      # for emacs lsp booster
      emacs-lsp-booster
      pkg-config
      # telega
      libwebp

      #
      # texliveFull

      # emacs-lsp-booster
      # ------------------- Python ---
      pyright
      ruff
      # poetry
      # ------------------- Web -------------------------

      typescript-language-server
      emmet-ls
      jsonnet-language-server
      yaml-language-server
      # Building tools
      # bazel_7
      dasel

      mermaid-cli
    ]
    ++ (lib.optionals pkgs.stdenv.isDarwin) [
      # pngpaste for org mode download clip
      pngpaste
      hugo
      org-reminders
    ];
in
{
  imports = [
    inputs.nix-doom-emacs-unstraightened.hmModule
  ];
  home.sessionVariables = {
    "EIDTOR" = "emacs";
  };
  stylix.targets.emacs.enable = false;
  # xdg.configFile."doom".source = config.lib.file.mkOutOfStoreSymlink doomPath;

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
      epkgs:
      with epkgs;

      let
        websocket-bridge = epkgs.melpaBuild {
          pname = "websocket-bridge";
          version = "9999snapshot1";
          packageRequires = [ epkgs.websocket ];
          src = builtins.fetchTree {
            type = "github";
            owner = "ginqi7";
            repo = "websocket-bridge";
            rev = "535364f8fefd791b22525b7640d291e88c80179d";
          };
        };
        org-reminders = epkgs.melpaBuild {
          pname = "org-reminders";
          version = "9999snapshot1";
          packageRequires = [
            websocket-bridge
            epkgs.org
            epkgs.transient
          ];
          src = builtins.fetchTree {
            type = "github";
            owner = "ginqi7";
            repo = "org-reminders";
            rev = "7d317b5591303265d86022de62498826285ba2c9";
          };
        };

      in
      [
        treesit-grammars.with-all-grammars
        rime
        telega
      ]
      ++ (lib.optionals pkgs.stdenv.isDarwin [
        websocket-bridge
        org-reminders
      ]);
    doomLocalDir = "${config.home.homeDirectory}/.cache/doom/rime";
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
