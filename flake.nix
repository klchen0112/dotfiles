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
  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirrors.cernet.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="

    ];
  };
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

      doom-emacs = {
        url = "github:LuigiPiucco/doom-emacs";
        flake = false;
      };


      nix-doom-emacs = {
        # Nix-community Doom Emacs
        url = "github:nix-community/nix-doom-emacs";
        inputs.doom-emacs.follows = "doom-emacs";
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
      apple-fonts = {
        url = "github:Lyndeno/apple-fonts.nix";
        inputs.flake-utils.follows = "flake-utils";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs =
    inputs @ { self
    , nixpkgs
    , home-manager
    , darwin
    , vscode-server
    , ...
    }:
    # Function that tells my flake which to use and what do what to do with the dependencies.
    let
      # Variables that can be used in the config files.
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

    in
    rec {
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );

      # Accessible through 'nix develop' or 'nix-shell' (legacy)
      overlays = import ./overlays { inherit inputs; };
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${ system};
        in import ./shell.nix { inherit pkgs; }
      );
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      darwinModules = import ./modules/darwin;

      nixosConfigurations =
        let
          username = "klchen";
        in
        {
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

            ];
          };
          "i12500" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs username outputs;

            };
            modules = [
              # hyprland.nixosModules.default
              vscode-server.nixosModules.default
              ./machines/i12500

            ];
          };
        };
      homeConfigurations = {
        "klchen@i12500" =
          let username = "klchen";
          in
          home-manager.lib.homeManagerConfiguration
            {
              pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
              extraSpecialArgs = { inherit inputs outputs username; };
              modules = [
                # > Our main home-manager configuration file <
                ./hosts/i12500
              ];
            };
        "klchen@wsl" =
          let username = "klchen";
          in
          home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
            extraSpecialArgs = { inherit inputs outputs username; };
            modules = [
              # > Our main home-manager configuration file <
              ./hosts/wsl
            ];
          };
        "chenkailong@macbook-pro-m1" = let username = "chenkailong"; in
          home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
            extraSpecialArgs = { inherit inputs outputs username; };
            modules = [
              # > Our main home-manager configuration file <
              ./hosts/macbook-pro-m1
            ];
          };

      };
      darwinConfigurations =
        let username = "chenkailong";
        in
        {
          "macbook-pro-m1" = darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            specialArgs = {
              inherit username inputs;
            };
            pkgs = nixpkgs.legacyPackages.aarch64-darwin;
            modules = [
              # Modules that are used
              ./machines/macbook-pro-m1
              darwinModules.sketchybar-bottom
            ];
          };
        };
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}

