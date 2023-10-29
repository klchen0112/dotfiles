{ inputs
, outputs
, lib
, config
, pkgs
, username
, ...
}: {
  # improts = [
  #   inputs.nix-doom-emacs.hmModule
  # ];
  home.packages = with pkgs; [
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
  ] ++ (lib.optionals pkgs.stdenv.isDarwin) [
    # pngpaste for org mode download clip
    pngpaste
  ];

  programs.pandoc.enable = true;

  # home.file.".config/emacs".source = inputs.doomemacs;
  home.file.".config/doom" = {
    source = ./doom;
    recursive = true;
    # onChange = "~/.config/emacs/bin/doom sync";
  };


  programs.emacs = {
    enable = true;
    package =
      if pkgs.stdenv.hostPlatform.isDarwin then
        pkgs.emacs-plus
      else
        pkgs.emacs29;
  };
  # doom-emacs will enable programs.emacs
  # programs.doom-emacs = {
  # enable = true;
  # doomPrivateDir = ./doom;
  # emacsPackage = pkgs.emacs29;
  # };
}
