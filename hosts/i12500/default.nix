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
    inputs.hyprland.homeManagerModules.default
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

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  programs.home-manager.enable = true;
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };
  home.stateVersion = "23.11";

}
