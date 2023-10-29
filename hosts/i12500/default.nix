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
    inputs.vscode-server.homeModules.default
    ../../modules/browser/home.nix
    ../../modules/downloader/home.nix
    ../../modules/editors/home.nix
    ../../modules/desktop/wayland
    ../../modules/graphics/home.nix
    ../../modules/keyboard/home.nix
    ../../modules/lang/home.nix
    ../../modules/media/home.nix
    ../../modules/network/home.nix
    ../../modules/shells/home.nix
    ../../modules/socialMedia/home.nix
    ../../modules/terminal/home.nix
    ../../modules/vm/home.nix
  ];

  programs.home-manager.enable = true;
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };
  home.stateVersion = "23.05";
}
