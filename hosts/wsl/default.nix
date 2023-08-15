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

    ../../home-manager/browser
    ../../home-manager/downloader
    # ../../home-manager/editors/codeblocks
    ../../home-manager/editors/jetbrains
    ../../home-manager/editors/emacs/default.nix
    # ../../home-manager/editors/vim
    # ../../home-manager/editors/nvim
    ../../home-manager/editors/vscode
    ../../home-manager/graphics
    ../../home-manager/keyboard
    ../../home-manager/lang/cpp
    ../../home-manager/lang/go
    ../../home-manager/lang/json
    ../../home-manager/lang/julia
    ../../home-manager/lang/lua
    ../../home-manager/lang/latex
    ../../home-manager/lang/markdown
    ../../home-manager/lang/nix
    ../../home-manager/lang/nodejs
    ../../home-manager/lang/python
    ../../home-manager/lang/rust
    ../../home-manager/media
    ../../home-manager/network
    ../../home-manager/notes
    ../../home-manager/office
    ../../home-manager/shells
    ../../home-manager/socialMedia
    ../../home-manager/terminal
    ../../home-manager/vm
    # ../../home-manager/vpn
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
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };
  home.stateVersion = "23.05";

}
