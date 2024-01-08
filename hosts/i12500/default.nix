{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  ...
}: {
  imports = [
    # inputs.nix-doom-emacs.hmModule
    inputs.nur.hmModules.nur
    ../../modules/browser/home.nix
    ../../modules/downloader/home.nix
    ../../modules/editors/home.nix
    ../../modules/desktop/wayland/home.nix
    ../../modules/graphics/home.nix
    ../../modules/keyboard/home.nix
    ../../modules/lang/home.nix
    ../../modules/media/home.nix
    ../../modules/network/home.nix
    ../../modules/shells/home.nix
    ../../modules/socialMedia/home.nix
    ../../modules/terminal/home.nix
    ../../modules/visualisation/home.nix
    ../../modules/nixpkgs/base.nix
    ../../modules/im/home.nix
    ../../modules/notes/home.nix
  ];

  programs.home-manager.enable = true;
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };
  home.stateVersion = "23.11";
}
