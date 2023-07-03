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
      nixpkgs.url = "github:nixos/nixpkgs/release-23.05"; # Nix Packages
      systems.url = "github:nix-systems/default";

      nixos-hardware = {
        url = "github:NixOS/nixos-hardware";
      };

      flake-utils = {
        url = "github:numtide/flake-utils";
        inputs.systems.follows = "systems";
      };

      flake-parts = {
        url = "github:hercules-ci/flake-parts";
      };

      flake-compat = {
        url = "github:edolstra/flake-compat";
        flake = false;
      };

      home-manager = {
        # User Package Management
        url = "github:nix-community/home-manager/release-23.05";
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
        inputs.flake-utils.follows = "flake-utils";
      };

      emacs-overlay = {
        url = "github:nix-community/emacs-overlay/master";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.flake-utils.follows = "flake-utils";
      };

      nix-doom-emacs = {
        # Nix-community Doom Emacs
        url = "github:nix-community/nix-doom-emacs";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.emacs-overlay.follows = "emacs-overlay";
        inputs.flake-utils.follows = "flake-utils";
        inputs.flake-compat.follows = "flake-compat";
      };

      hyprland = {
        # Official Hyprland flake
        url = "github:vaxerski/Hyprland";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      vscode-server = {
        url = "github:msteen/nixos-vscode-server";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.flake-utils.follows = "flake-utils";
      };
      nixos-wsl = {
        url = "github:nix-community/NixOS-WSL";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.flake-utils.follows = "flake-utils";
        inputs.flake-compat.follows = "flake-compat";
      };
      # fonts
    };

  outputs =
    inputs @ { self
    , nixpkgs
    , home-manager
    , flake-utils
    , darwin
    , nur
    , nixgl
    , nixos-wsl
    , emacs-overlay
    , nix-doom-emacs
    , hyprland
    , vscode-server
    , ...
    }:
    # Function that tells my flake which to use and what do what to do with the dependencies.
    let
      # Variables that can be used in the config files.
      username = "chenkailong";
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
    in
    rec {
      nixosConfigurations = {
        # NixOS configurations
        "wsl" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs username;
          };
          modules = [
            ./machines/wsl
            vscode-server.nixosModule
            ({ config
             , pkgs
             , ...
             }: {
              services.vscode-server.enable = true;
            })
            home-manager.darwinModules.home-manager
            modules/hosts/wsl/default.nix
          ];
        };
      };
      darwinConfigurations =
        let
          system = "aarch64-darwin";
        in
        {
          "macbook-pro-m1" = darwin.lib.darwinSystem {
            inherit system;
            specialArgs = {
              inherit username inputs system;
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
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

    };
}
