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

    ../../browser
    ../../downloader
    # ../../editors/codeblocks
    ../../editors/jetbrains
    ../../editors/emacs/default.nix
    # ../../editors/vim
    # ../../editors/nvim
    ../../editors/vscode
    ../../graphics
    ../../keyboard
    ../../lang/cpp
    ../../lang/go
    ../../lang/json
    ../../lang/julia
    ../../lang/lua
    ../../lang/latex
    ../../lang/markdown
    ../../lang/nix
    ../../lang/nodejs
    ../../lang/python
    ../../lang/rust
    ../../media
    ../../network
    ../../notes
    ../../office
    ../../shells
    ../../socialMedia
    ../../terminal
    ../../vm
    ../../windowManager
    # ../../vpn
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
    homeDirectory = "/Users/${username}";
  };
  home.stateVersion = "23.05";

}
