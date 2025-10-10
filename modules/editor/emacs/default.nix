{ inputs, ... }:
{
  flake-file.inputs = {
    emacs-overlay = {
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
      url = "github:nix-community/emacs-overlay/master";
    };
  };
  flake.modules.homeManager.emacs =
    {
      lib,
      pkgs,
      ...
    }:
    let
      emacsPackage = pkgs.emacsWithPackagesFromUsePackage {
        package = if pkgs.stdenv.isDarwin then pkgs.local.emacsIGC else pkgs.emacs-igc-pgtk;
        alwaysEnsure = true;
        alwaysTangle = true;
        defaultInitFile = true;
        config = ./config.org;
        extraEmacsPackages = epkgs: [
          epkgs.treesit-grammars.with-all-grammars
          epkgs.rime
          epkgs.telega
        ];
      };
    in
    {
      nixpkgs.overlays = [
        inputs.emacs-overlay.overlays.default
      ];
      programs.emacs = {
        enable = true;
        package = emacsPackage;
      };
      services.emacs = {
        enable = true;
        client.enable = true;
        socketActivation.enable = true;
        startWithUserSession = "graphical";
      };
      home.packages =
        with pkgs;
        [
          fd
          curl
          # org mode dot
          graphviz
          imagemagick
          # mpvi required
          # tesseract5
          # ffmpeg
          # poppler
          # ffmpegthumbnailer
          # mediainfo
          # sqlite
          # email
          # mu4e
          # spell check
          # hunspell
          # languagetool
          # for emacs lsp booster
          emacs-lsp-booster
          pkg-config
        ]
        ++ (lib.optionals pkgs.stdenv.isDarwin) [
          # pngpaste for org mode download clip
          pngpaste
          hugo
          pkgs.local.org-reminders
        ];

    };
}
