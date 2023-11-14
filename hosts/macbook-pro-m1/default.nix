{ inputs
, outputs
, lib
, config
, pkgs
, username
, ...
}: {
  imports = [
    inputs.nix-doom-emacs.hmModule
    ../../modules/browser/home.nix
    ../../modules/downloader/home.nix
    ../../modules/editors/home.nix
    ../../modules/graphics/home.nix
    ../../modules/keyboard/home.nix
    ../../modules/lang/home.nix
    ../../modules/media/home.nix
    ../../modules/network/home.nix
    ../../modules/shells/home.nix
    ../../modules/socialMedia/home.nix
    ../../modules/terminal/home.nix
    ../../modules/vm/home.nix
    ../../modules/im/home.nix
    # ../../modules/windowManager
    # ../../modules/vpn
    ../../modules/notes/home.nix
  ];


  home = {
    username = "${username}";
    homeDirectory = "/Users/${username}";
    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;
}
