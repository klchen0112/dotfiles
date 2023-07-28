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
{ config
, lib
, pkgs
, username
, system
, inputs
, ...
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
    tesseract5
    ffmpeg_5
    # pngpaste for org mode download clip
    pngpaste

  ];
  # programs.emacs = {
  #   enable = true;
  #   package = pkgs.emacs-unstable;
  # };
  # doom-emacs will enable programs.emacs
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom;
    # emacsPackagesOverlay = self: super: {
    #   lsp-pyright = super.lsp-pyright.overrideAttrs (esuper: {
    #     buildInputs = esuper.buildInputs ++ [
    #       pkgs.nodePackages.pyright
    #     ];
    #   });
    # };

    # emacsPackage = pkgs.emacs29;
    # emacsPackagesOverlay = self: super: {
    #   mpvi = self.trivialBuild {
    #     pname = "mpvi";
    #     ename = "mpvi";
    #     version = "unstable-2023-06-08";
    #     # buildInputs = [  ];
    #     src = pkgs.fetchFromGitHub {
    #       owner = "lorniu";
    #       repo = "mpvi";
    #       rev = "f633510686d7b974147592336fa21ce6df80a5da";
    #       sha256 = "sha256-TxsGaG2fBRWWP9aas59kiNnUVD4ZdNlwwaFbM4+n81c=";
    #     };
    #   };
    #   org-anki = self.trivialBuild {
    #     pname = "org-anki";
    #     ename = "org-anki";
    #     version = "v3.1.1";
    #     buildInputs = [ pkgs.ffmpeg_5 pkgs.tesseract5 ];
    #     src = pkgs.fetchFromGitHub {
    #       owner = "eyeinsky";
    #       repo = "org-anki";
    #       rev = "2a0f7b4a5527411e541997309afc7d5aab59d3e8";
    #       sha256 = "sha256-TxsGaG2fBRWWP9aas59kiNnUVD4ZdNlwwaFbM4+n81c=";
    #     };
    #   };
    # };

  };
}
