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
    # email
    # mu4e
    isync
    mu

  ] ++ (lib.optionals pkgs.stdenv.isDarwin) [
    # pngpaste for org mode download clip
    pngpaste
  ];

  # home.file.".config/emacs".source = inputs.doomemacs;
  home.file.".config/doom".source = ./doom;


  programs.emacs = {
    enable = true;
    package = pkgs.emacs29;
  };
  # doom-emacs will enable programs.emacs
  # programs.doom-emacs = {
  #   enable = true;
  #   doomPrivateDir = ./doom;
  #   # emacsPackagesOverlay = self: super: {
  #   #   lsp-pyright = super.lsp-pyright.overrideAttrs (esuper: {
  #   #     buildInputs = esuper.buildInputs ++ [
  #   #       pkgs.nodePackages.pyright
  #   #     ];
  #   #   });
  #   # };
  #   extraConfig =
  #     # this code from https://github.com/ckiee/nixfiles/blob/main/modules/doom-emacs/default.nix
  #     ''
  #       (setq exec-path (append exec-path      '("/run/wrappers/bin" "/etc/profiles/per-user/${username}/bin" "/nix/var/nix/profiles/default/bin" "/run/current-system/sw/bin" "/opt/homebrew/bin")))
  #       (setenv "PATH" (concat (getenv "PATH") ":/run/wrappers/bin:/etc/profiles/per-user/${username}/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:/opt/homebrew/bin"))
  #     '';
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
  # };
}
