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
      nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11"; # Nix Packages
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # Nix Packages
      nixos-hardware.url = "github:NixOS/nixos-hardware";

      flake-utils.url = "github:numtide/flake-utils";
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
        url = "github:nix-community/nix-doom-emacs";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      hyprland = {
        # Official Hyprland flake
        url = "github:vaxerski/Hyprland";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # fonts
    };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    flake-utils,
    darwin,
    nur,
    nixgl,
    emacs-overlay,
    hyprland,
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
  in rec {
    # Accessible through 'nix develop' or 'nix-shell' (legacy)
    legacyPackages = forAllSystems (system:
      import inputs.nixpkgs {
        inherit system;
        # This adds our overlays to pkgs
        overlays = [
          emacs-overlay.overlay
          (final: prev: {
            sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation rec {
              pname = "sf-mono-liga-bin";
              version = "dev";
              src = inputs.sf-mono-liga-src;
              dontConfigure = true;
              installPhase = ''
                mkdir -p $out/share/fonts/opentype
                cp -R $src/*.otf $out/share/fonts/opentype/
              '';
            };
          })
        ];

        # NOTE: Using `nixpkgs.config` in your NixOS config won't work
        # Instead, you should set nixpkgs configs here
        # (https://nixos.org/manual/nixpkgs/stable/#idm140737322551056)
        config.allowUnfree = true;
        config.allowBroken = false;
      });
    legacyPackages-unstable = forAllSystems (system:
      import inputs.nixpkgs-unstable {
        inherit system;

        # NOTE: Using `nixpkgs.config` in your NixOS config won't work
        # Instead, you should set nixpkgs configs here
        # (https://nixos.org/manual/nixpkgs/stable/#idm140737322551056)
        config.allowUnfree = true;
        config.allowBroken = false;
      });
    nixosConfigurations = {
      # NixOS configurations
      "wsl" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs user;
          pkgs-unstable = legacyPackages-unstable.x86_64-linux;
        };
        modules = [
          ./machines/wsl
        ];
      };
    };
    homeConfigurations = {
      "chenkailong@macbook-pro-m1" = home-manager.lib.homeManagerConfiguration {
        pkgs = legacyPackages.aarch64-darwin;
        extraSpecialArgs = {
          inherit inputs;
          pkgs-unstable = legacyPackages-unstable.aarch64-darwin;
        }; # Pass flake inputs to our config
        modules = [./modules/hosts/macbook-pro-m1];
      };
    };
    darwinConfigurations = {
      "macbook-pro-m1" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit user inputs;
          pkgs-unstable = legacyPackages-unstable.aarch64-darwin;
        };
        pkgs = legacyPackages.aarch64-darwin;
        modules = [
          # Modules that are used
          ./machines/macbook-pro-m1
          # home-manager.darwinModules.home-manager
          # {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          # }
        ];
      };
    };

    formatter =
      forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    nixConfig = {
      commit-lockfile-summary = "flake: bump inputs";
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://cache.ngi0.nixos.org/"
        "https://nix-community.cachix.org?priority=5"
        "https://nixpkgs-wayland.cachix.org"
        "https://fortuneteller2k.cachix.org"
      ];
    };
  };
}
