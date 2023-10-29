{ inputs
, outputs
, lib
, config
, pkgs
, username
, ...
}: {
  imports = [
    # inputs.nix-doom-emacs.hmModule
    inputs.vscode-server.homeModules.default
    ../../home-manager/desktop
    ../../home-manager/browser
    ../../home-manager/downloader
    ../../home-manager/editors
    ../../home-manager/graphics
    ../../home-manager/keyboard
    ../../home-manager/lang
    ../../home-manager/media
    ../../home-manager/network
    ../../home-manager/notes
    ../../home-manager/office
    ../../home-manager/shells
    ../../home-manager/socialMedia
    ../../home-manager/terminal
    ../../home-manager/vm
    ../../home-manager/vpn
  ];

  programs.home-manager.enable = true;
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };
  home.stateVersion = "23.05";

}
