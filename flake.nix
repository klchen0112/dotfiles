{
  description = "My Personal NixOS and Darwin System Flake Configuration";
  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    substituters = [
      # replace official cache with a mirror located in China
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://klchen0112.cachix.org"
      "https://devenv.cachix.org"
      "https://cosmic.cachix.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "klchen0112.cachix.org-1:cO5Ek4gcvoWtHslHjWn9U5ymU8ZiN7+tJo0jifbtRz4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];

    trusted-users = [
      "root"
      "@wheel"
      "chenkailong_dxm"
      "klchen"
    ];
    accept-flake-config = true;
    # extra-experimental-features = "nix-command flakes";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      darwin,
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
    in
    rec {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./pkgs { inherit pkgs inputs; }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt-rfc-style.enable = true; # formatter
            # deadnix.enable = true; # detect unused variable bindings in `*.nix`
            # statix.enable = true; # lints and suggestions for Nix code(auto suggestions)
            prettier = {
              enable = true;
              excludes = [
                ".js"
                ".md"
                ".ts"
              ];
            };

            # Shell
            shellcheck = {
              enable = true;
            };
            shfmt = {
              enable = true;
            };
            # TOML
            taplo.enable = true;
            # JSON
            pretty-format-json.enable = true;
          };
        };
      });
      devShell = forAllSystems (
        system:
        nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
        }
      );

      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        # NixOS configurations

        "i12r70" =
          let
            username = "klchen";
            userEmail = "klchen0112@gmail.com";
            isWork = false;
          in
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs username outputs; };
            modules = [
              inputs.nixos-wsl.nixosModules.default
              inputs.stylix.nixosModules.stylix
              {
                system.stateVersion = "25.05";
                wsl = {
                  enable = true;
                  defaultUser = username;
                  wslConf.automount.root = "/mnt";
                  wslConf.interop.appendWindowsPath = false;
                  wslConf.network.generateHosts = false;
                  startMenuLaunchers = true;
                  docker-desktop.enable = false;
                };
                # Enable integration with Docker Desktop (needs to be installed)
              }
              ./machines/i12r70
              home-manager.nixosModules.home-manager
              {
                # Home-Manager module that is used
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {
                  inherit
                    username
                    userEmail
                    inputs
                    outputs
                    isWork
                    ;
                }; # Pass flake variable
                home-manager.users.${username} = import ./hosts/i12r70/default.nix;
              }
            ];
          };
        "3400g" =
          let
            username = "klchen";
            userEmail = "klchen0112@gmail.com";
            isWork = false;
          in
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs username outputs; };
            modules = [
              ./machines/3400g
              home-manager.nixosModules.home-manager
              {
                # Home-Manager module that is used
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {
                  inherit
                    username
                    userEmail
                    inputs
                    outputs
                    isWork
                    ;
                }; # Pass flake variable
                home-manager.users.${username} = import ./hosts/3400g/default.nix;
              }
            ];
          };
      };
      darwinConfigurations = {
        "mbp-m1" =
          let
            username = "klchen";
            userEmail = "klchen0112@gmail.com";
            isWork = false;
          in
          darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            specialArgs = {
              inherit
                username
                inputs
                outputs
                isWork
                ;
            };
            # pkgs = nixpkgs.legacyPackages.aarch64-darwin;
            modules = [
              # Modules that are used
              ./machines/mbp-m1
              home-manager.darwinModules.home-manager
              {
                home-manager.backupFileExtension = "backup";
                # Home-Manager module that is used
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {
                  inherit
                    username
                    userEmail
                    inputs
                    outputs
                    isWork
                    ;
                }; # Pass flake variable
                home-manager.users.${username} = import ./hosts/mbp-m1/default.nix;
              }

            ];
          };
        "mbp-dxm" =
          let
            username = "chenkailong_dxm";
            userEmail = "chenkailong@duxiaoman.com";
            isWork = true;
          in
          darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            specialArgs = {
              inherit
                username
                inputs
                outputs
                isWork
                ;
            };
            # pkgs = nixpkgs.legacyPackages.aarch64-darwin;
            modules = [
              # inputs.stylix.darwinModules.stylix
              # Modules that are used
              ./machines/mbp-dxm
              home-manager.darwinModules.home-manager
              {
                # Home-Manager module that is used
                home-manager.backupFileExtension = "backup";
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {
                  inherit
                    username
                    userEmail
                    inputs
                    outputs
                    isWork
                    ;
                }; # Pass flake variable
                home-manager.users.${username} = import ./hosts/mbp-dxm/default.nix;
              }
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
      nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # Nix Packages
      nixpkgs-unstable.url = "github:nixos/nixpkgs/master"; # Nix Packages
      nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.11"; # Nix Packages

      #  MacOS
      darwin = {
        url = "github:LnL7/nix-darwin"; # MacOS Package Management
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Optional: Declarative tap management
      brew-nix = {
        # for local testing via `nix flake check` while developing
        #url = "path:../";
        url = "github:BatteredBunny/brew-nix";
        inputs.nix-darwin.follows = "darwin";
        inputs.brew-api.follows = "brew-api";
        inputs.flake-utils.follows = "flake-utils";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      brew-api = {
        url = "github:BatteredBunny/brew-api";
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
      # agenix = {
      #   url = "github:ryantm/agenix";
      #   inputs.darwin.follows = "darwin";
      #   inputs.home-manager.follows = "home-manager";
      #   inputs.nixpkgs.follows = "nixpkgs";
      #   inputs.systems.follows = "systems";
      # };

      # add git hooks to format nix code before commit
      pre-commit-hooks = {
        url = "github:cachix/git-hooks.nix";
        inputs.nixpkgs.follows = "nixpkgs";
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
      };

      nixpkgs-lib = {
        url = "github:nix-community/nixpkgs.lib";
      };

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

      agenix = {
        url = "github:ryantm/agenix";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.darwin.follows = "darwin";
      };

      nur = {
        url = "github:nix-community/NUR"; # NUR Packages
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.flake-parts.follows = "flake-parts";
        inputs.treefmt-nix.follows = "treefmt-nix";
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
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.nixpkgs-stable.follows = "nixpkgs-stable";
      };

      # doomemacs = {
      #   url = "github:LuigiPiucco/doom-emacs";
      #   flake = false;
      # };

      doom-config = {
        url = "github:klchen0112/doom";
        # url = "git+file:///Users/klchen/my/doom";
        flake = false;
      };

      # nix-doom-emacs-unstraightened = {
      #   url = "github:marienz/nix-doom-emacs-unstraightened";
      #   # Optional, to download less. Neither the module nor the overlay uses this input.
      #   inputs.nixpkgs.follows = "nixpkgs";
      #   inputs.systems.follows = "systems";
      #   inputs.emacs-overlay.follows = "emacs-overlay";
      #   inputs.doomemacs.follows = "doomemacs";
      # };

      nixos-cosmic = {
        url = "github:lilyinstarlight/nixos-cosmic";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.nixpkgs-stable.follows = "nixpkgs-stable";
        inputs.flake-compat.follows = "flake-compat";
      };
      # theme
      stylix = {
        url = "github:danth/stylix";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "home-manager";
        inputs.git-hooks.follows = "pre-commit-hooks";
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

      agenix-secrets = {
        url = "github:klchen0112/agenix-secrets";
        flake = false;
      };
    };
}
