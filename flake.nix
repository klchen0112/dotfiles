#
#  G'Day
#  Behold is my personal Nix, NixOS and Darwin Flake.
#  I'm not the sharpest tool in the shed, so this build might not be the best out there.
#  I refer to the README and other org document on how to use these files.
#  Currently and possibly forever a Work In Progress.
#
#  flake.nix *
#   ├─ ./hosts
#   │   └─ default.nix
#   ├─ ./darwin
#   │   └─ default.nix
#   └─ ./nix
#       └─ default.nix
#
{
  description = "My Personal NixOS and Darwin System Flake Configuration";

  inputs =
    # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # Nix Packages
      nixos-hardware.url = "github:NixOS/nixos-hardware";

      flake-utils.url = "github:numtide/flake-utils";
      flake-parts.url = "github:hercules-ci/flake-parts";

      home-manager = {
        # User Package Management
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      darwin = {
        url = "github:lnl7/nix-darwin/master"; # MacOS Package Management
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nur = {
        url = "github:nix-community/NUR"; # NUR Packages
      };

      nixgl = {
        # OpenGL
        url = "github:guibou/nixGL";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      emacs-overlay = {
        url = "github:nix-community/emacs-overlay/master";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      doom-emacs = {
        # Nix-community Doom Emacs
        url = "github:nix-community/nix-doom-emacs";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.emacs-overlay.follows = "emacs-overlay";
      };

      hyprland = {
        # Official Hyprland flake
        url = "github:vaxerski/Hyprland";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      vscode-server.url = "github:msteen/nixos-vscode-server";

      # fonts
    };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    flake-utils,
    darwin,
    nur,
    nixgl,
    emacs-overlay,
    hyprland,
    vscode-server,
    ...
  }:
  # Function that tells my flake which to use and what do what to do with the dependencies.
  let
    # Variables that can be used in the config files.
    user = "chenkailong";
    location = "$HOME/.config";
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # Accessible through 'nix develop' or 'nix-shell' (legacy)
    legacyPackages = forAllSystems (system:
      import inputs.nixpkgs {
        inherit system;
        # This adds our overlays to pkgs
        overlays = [
          emacs-overlay.overlay
        ];
        # NOTE: Using `nixpkgs.config` in your NixOS config won't work
        # Instead, you should set nixpkgs configs here
        # (https://nixos.org/manual/nixpkgs/stable/#idm140737322551056)
        config.allowUnfree = true;
        config.allowBroken = true;
        # config.allowUnsupportedSystem = true;
      });
  in rec {
    # nixosConfigurations = {
    #   # NixOS configurations
    #   "wsl" = nixpkgs.lib.nixosSystem {
    #     system = "x86_64-linux";
    #     specialArgs = {
    #       inherit inputs user;
    #     };
    #     modules = [
    #       ./machines/wsl
    #       vscode-server.nixosModule
    #       ({
    #         config,
    #         pkgs,
    #         ...
    #       }: {
    #         services.vscode-server.enable = true;
    #       })
    #     ];
    #   };
    # };
    darwinConfigurations = {
      "macbook-pro-m1" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit user inputs;
        };
        pkgs = legacyPackages.aarch64-darwin;
        modules = [
          # Modules that are used
          ./machines/macbook-pro-m1
          home-manager.darwinModules.home-manager
          modules/hosts/macbook-pro-m1/default.nix
        ];
      };
    };

    formatter =
      forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
