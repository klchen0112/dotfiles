{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  imports = [
    # inputs.nix-doom-emacs.hmModule
    ../../modules/ai/home.nix
    ../../modules/browser/home.nix
    ../../modules/downloader/home.nix
    ../../modules/editors/home.nix
    ../../modules/graphics/home.nix
    ../../modules/keyboard/home.nix
    ../../modules/lang/home.nix
    ../../modules/media/home.nix
    ../../modules/network/home.nix
    ../../modules/sync/home.nix
    ../../modules/shells/home.nix
    ../../modules/socialMedia/home.nix
    ../../modules/terminal/home.nix
    ../../modules/visualisation/home.nix
    ../../modules/im/home.nix
    ../../modules/nixpkgs/home.nix
    # ../../modules/windowManager
    # ../../modules/vpn
    ../../modules/notes/home.nix
    ../../modules/stylix/home.nix

  ];

  home = {
    username = "${username}";
    homeDirectory = "/Users/${username}";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}
