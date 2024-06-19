{
  description = "My Personal NixOS and Darwin System Flake Configuration";
  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    substituters = [
      # replace official cache with a mirror located in China
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://anyrun.cachix.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://ruixi-rebirth.cachix.org"
      "https://klchen0112.cachix.org"
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      "klchen0112.cachix.org-1:cO5Ek4gcvoWtHslHjWn9U5ymU8ZiN7+tJo0jifbtRz4="
      "ryan4yin.cachix.org-1:Gbk27ZU5AYpGS9i3ssoLlwdvMIh0NxG0w8it/cv9kbU="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "ruixi-rebirth.cachix.org-1:sWs3V+BlPi67MpNmP8K4zlA3jhPCAvsnLKi4uXsiLI4="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
    trusted-users = ["root" "@wheel"];
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    darwin,
    nix-homebrew,
    pre-commit-hooks,
    nix-on-droid,
    ...
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
  in rec {
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      import ./pkgs {inherit pkgs inputs;});

    formatter =
      forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    checks = forAllSystems (system: {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true; # formatter
          # deadnix.enable = true; # detect unused variable bindings in `*.nix`
          # statix.enable = true; # lints and suggestions for Nix code(auto suggestions)
          prettier = {
            enable = true;
            excludes = [".js" ".md" ".ts"];
          };
        };
      };
    });
    devShell = forAllSystems (system:
      nixpkgs.legacyPackages.${system}.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
      });

    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      # NixOS configurations

      "i12500" = let
        username = "klchen";
        userEmail = "klchen0112@gmail.com";
      in
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs username outputs;};
          modules = [
            # hyprland.nixosModules.default
            ./machines/i12500
            inputs.agenix.nixosModules.default
          ];
        };
    };
    homeConfigurations = {
      "klchen@i12500" = let
        username = "klchen";
        userEmail = "klchen0112@gmail.com";
        isWork = false;
      in
        home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {inherit inputs outputs username userEmail;};
          modules = [
            # > Our main home-manager configuration file <
            ./hosts/i12500
            inputs.agenix.homeManagerModules.default
          ];
        };
    };
    darwinConfigurations = {
      "mbp-m1" = let
        username = "klchen";
        userEmail = "klchen0112@gmail.com";
        isWork = false;
      in
        darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {inherit username inputs outputs isWork;};
          # pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [
            # Modules that are used
            ./machines/mbp-m1
            home-manager.darwinModules.home-manager
            {
              # Home-Manager module that is used
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit username userEmail inputs outputs isWork;
              }; # Pass flake variable
              home-manager.users.${username} =
                import ./hosts/mbp-m1/default.nix;
            }
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                # Install Homebrew under the default prefix
                enable = true;

                # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
                enableRosetta = false;

                # User owning the Homebrew prefix
                user = "klchen";
                taps = with inputs; {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-services" = homebrew-services;
                };
                # Optional: Enable fully-declarative tap management
                #
                # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
                mutableTaps = true;
                # Automatically migrate existing Homebrew installations
                autoMigrate = false;
              };
            }
            inputs.agenix.darwinModules.default
          ];
        };
      "mbp-m2-dxm" = let
        username = "chenkailong_dxm";
        userEmail = "chenkailong@duxiaoman.com";
        isWork = true;
      in
        darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {inherit username inputs outputs isWork;};
          # pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [
            # Modules that are used
            ./machines/mbp-m2-dxm
            home-manager.darwinModules.home-manager
            {
              # Home-Manager module that is used
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit username userEmail inputs outputs isWork;
              }; # Pass flake variable
              home-manager.users.${username} =
                import ./hosts/mbp-m2-dxm/default.nix;
            }
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                # Install Homebrew under the default prefix
                enable = true;

                # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
                enableRosetta = false;

                # User owning the Homebrew prefix
                user = "chenkailong_dxm";
                taps = with inputs; {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-services" = homebrew-services;
                };
                # Optional: Enable fully-declarative tap management
                #
                # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
                mutableTaps = false;
                # Automatically migrate existing Homebrew installations
                autoMigrate = false;
              };
            }
            inputs.agenix.darwinModules.default
          ];
        };
    };
    nixOnDroidConfigurations = {
      "redmi-12t-pro" = nix-on-droid.lib.nixOnDroidConfiguration {
        modules = [
          ./machines/redmi-12t-pro
        ];
      };
    };
  };

  inputs =
    # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Nix Packages
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # Nix Packages

      #  MacOS
      darwin = {
        url = "github:lnl7/nix-darwin/master"; # MacOS Package Management
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nix-homebrew = {
        url = "github:zhaofengli-wip/nix-homebrew";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.nix-darwin.follows = "darwin";
        inputs.flake-utils.follows = "flake-utils";
      };
      # Optional: Declarative tap management
      homebrew-core = {
        url = "github:homebrew/homebrew-core";
        flake = false;
      };
      homebrew-cask = {
        url = "github:homebrew/homebrew-cask";
        flake = false;
      };
      homebrew-services = {
        url = "github:homebrew/homebrew-services";
        flake = false;
      };

      # Home Manager
      home-manager = {
        # User Package Management
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Android
      nix-on-droid = {
        url = "github:nix-community/nix-on-droid/release-23.11";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "home-manager";
      };

      systems.url = "github:nix-systems/default";

      # secrets management
      agenix = {
        url = "github:ryantm/agenix";
        inputs.darwin.follows = "darwin";
        inputs.home-manager.follows = "home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # add git hooks to format nix code before commit
      pre-commit-hooks = {
        url = "github:cachix/git-hooks.nix";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
        inputs.nixpkgs-stable.follows = "nixpkgs";
        inputs.flake-compat.follows = "flake-compat";
      };

      devshell = {
        url = "github:numtide/devshell";
        inputs.nixpkgs.follows = "nixpkgs";
        # inputs.systems.follows = "systems";
      };

      flake-utils = {
        url = "github:numtide/flake-utils";
        inputs.systems.follows = "systems";
      };

      treefmt-nix = {
        url = "github:numtide/treefmt-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      flake-parts = {
        url = "github:hercules-ci/flake-parts";
        inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      };

      flake-compat = {
        url = "github:edolstra/flake-compat";
        flake = false;
      };

      nixpkgs-lib.url = "github:nix-community/nixpkgs.lib";
      lib-aggregate = {
        # User Package Management
        url = "github:nix-community/lib-aggregate";
        inputs.flake-utils.follows = "flake-utils";
        inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      };

      nix-eval-jobs = {
        # User Package Management
        url = "github:nix-community/nix-eval-jobs";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.flake-parts.follows = "flake-parts";
        inputs.treefmt-nix.follows = "treefmt-nix";
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

      # devenv = {
      #   url = "github:cachix/devenv";
      #   # inputs.nixpkgs.follows = "nixpkgs";
      #   # inputs.flake-compat.follows = "flake-compat";
      #   # inputs.pre-commit-hooks.follows = "pre-commit-hooks";
      # };

      nixos-wsl = {
        url = "github:nix-community/NixOS-WSL";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.flake-utils.follows = "flake-utils";
        inputs.flake-compat.follows = "flake-compat";
      };

      nix-vscode-extensions = {
        url = "github:nix-community/nix-vscode-extensions";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
        inputs.flake-utils.follows = "flake-utils";
        inputs.flake-compat.follows = "flake-compat";
      };

      emacs-overlay = {
        url = "github:nix-community/emacs-overlay/master";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
        inputs.nixpkgs-stable.follows = "nixpkgs";
        inputs.flake-utils.follows = "flake-utils";
      };

      # doom-emacs = {
      #   url = "github:LuigiPiucco/doom-emacs";
      #   flake = false;
      # };

      # nix-doom-emacs = {
      #   # Nix-community Doom Emacs
      #   url = "github:nix-community/nix-doom-emacs";
      #   inputs.doom-emacs.follows = "doom-emacs";
      #   inputs.nixpkgs.follows = "nixpkgs";
      #   inputs.emacs-overlay.follows = "emacs-overlay";
      #   inputs.flake-utils.follows = "flake-utils";
      #   inputs.flake-compat.follows = "flake-compat";
      # };
      nix-doom-emacs-unstraightened = {
        url = "github:marienz/nix-doom-emacs-unstraightened";
        # Optional, to download less. Neither the module nor the overlay uses this input.
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.systems.follows = "systems";
        inputs.emacs-overlay.follows = "emacs-overlay";
      };

      # hyprland

      # nixpkgs-wayland = {
      #   url = "github:nix-community/nixpkgs-wayland";
      #   inputs.nixpkgs.follows = "nixpkgs";
      #   inputs.flake-compat.follows = "flake-compat";
      #   inputs.nix-eval-jobs.follows = "nix-eval-jobs";
      #   inputs.lib-aggregate.follows = "lib-aggregate";
      # };

      hyprland = {
        # Official Hyprland flake
        url = "github:hyprwm/Hyprland/v0.33.1";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.systems.follows = "systems";
        inputs.hyprland-protocols.follows = "hyprland-protocols";
      };

      hyprland-protocols = {
        # Official Hyprland flake
        url = "github:hyprwm/hyprland-protocols";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.systems.follows = "systems";
      };

      hyprpaper = {
        url = "github:hyprwm/hyprpaper";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.systems.follows = "systems";
        inputs.hyprlang.follows = "hyprlang";
      };

      hyprpicker = {
        url = "github:hyprwm/hyprpicker";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      hyprcontrib = {
        url = "github:hyprwm/contrib";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      hyprlang = {
        url = "github:hyprwm/hyprlang";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.systems.follows = "systems";
      };

      anyrun = {
        url = "github:Kirottu/anyrun";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      hycov = {
        url = "github:DreamMaoMao/hycov";
        inputs.hyprland.follows = "hyprland";
      };

      nixpkgs-firefox-darwin = {
        url = "github:bandithedoge/nixpkgs-firefox-darwin";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      # own package
      own-nur = {
        url = "github:klchen0112/nur";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      own-rime = {
        url = "github:klchen0112/rime-combo-ice-pinyin";
        flake = false;
      };
    };
}
