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
      "https://nix-community.cachix.org"
      "https://klchen0112.cachix.org"
      "https://cosmic.cachix.org"

      "https://colmena.cachix.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "klchen0112.cachix.org-1:cO5Ek4gcvoWtHslHjWn9U5ymU8ZiN7+tJo0jifbtRz4="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
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
      nix-on-droid,
      srvos,
      treefmt-nix,
      systems,
      ...
    }:
    # Function that tells my flake which to use and what do what to do with the dependencies.
    let
      # Variables that can be used in the config files.
      inherit (self) outputs;
      # Small tool to iterate over each systems
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    rec {
      packages = eachSystem (pkgs: import ./pkgs { inherit pkgs inputs; });

      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });

      devShell = eachSystem (
        pkgs:
        pkgs.mkShell {
          buildInputs = [ pkgs.just ];
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
              ./machines/i12r70
              home-manager.nixosModules.home-manager
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
                home-manager.users.${username} = import ./hosts/i12r70/default.nix;
              }
            ];
          };

        "i12r70-wsl" =
          let
            username = "klchen";
            userEmail = "klchen0112@gmail.com";
            isWork = false;
          in
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs username outputs; };
            modules = [
              srvos.nixosModules.server
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
              ./machines/i12r70-wsl
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
                home-manager.users.${username} = import ./hosts/i12r70-wsl/default.nix;
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
                home-manager.users.${username} = import ./hosts/3400g/default.nix;
              }
            ];
          };
        "sanjiao" =
          let
            username = "klchen";
            userEmail = "klchen0112@gmail.com";
            isWork = false;
          in
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs username outputs; };
            modules = [
              ./machines/sanjiao
              home-manager.nixosModules.home-manager
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
                home-manager.users.${username} = import ./hosts/sanjiao/default.nix;
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
              srvos.darwinModules.desktop
              srvos.darwinModules.mixins-terminfo
              srvos.darwinModules.mixins-nix-experimental
              srvos.darwinModules.mixins-trusted-nix-caches
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
              srvos.darwinModules.desktop
              srvos.darwinModules.mixins-terminfo
              srvos.darwinModules.mixins-nix-experimental
              srvos.darwinModules.mixins-trusted-nix-caches
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
      colmena =
        let
          username = "klchen";
          userEmail = "klchen0112@gmail.com";
          isWork = false;
        in
        {
          meta = {
            nixpkgs = import nixpkgs { system = "x86_64-linux"; };

            # 这个参数的功能与 `nixosConfigurations.xxx` 中的 `specialArgs` 一致，
            # 都是用于传递自定义参数到所有子模块。
            specialArgs = {
              inherit inputs username outputs;
            };
          };
          "sanjiao" =
            { name, nodes, ... }:
            {
              deployment.targetHost = "192.168.0.192"; # 远程主机的 IP 地址
              deployment.targetUser = "root"; # 远程主机的用户名

              imports = [
                ./machines/sanjiao
                home-manager.nixosModules.home-manager
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
                  home-manager.users.${username} = import ./hosts/sanjiao/default.nix;
                }
              ];
            };
          "3400g" =
            { name, nodes, ... }:
            {
              deployment.targetHost = "192.168.0.197"; # 远程主机的 IP 地址
              deployment.targetUser = "root"; # 远程主机的用户名
              imports = [
                ./machines/3400g
                home-manager.nixosModules.home-manager
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
                  home-manager.users.${username} = import ./hosts/3400g/default.nix;
                }
              ];
            };

        };
    };

  inputs =
    # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=nixos-unstable"; # Nix Packages
      nixpkgs-unstable.url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=master"; # Nix Packages
      nixpkgs-stable.url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=release-24.11"; # Nix Packages

      srvos = {
        url = "github:nix-community/srvos";
        inputs.nixpkgs.follows = "nixpkgs";
      };
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
        url = "git+https://github.com/nix-community/nix-on-droid?shallow=1&ref=master";
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

      devshell = {
        url = "github:numtide/devshell";
        inputs.nixpkgs.follows = "nixpkgs";
        # inputs.systems.follows = "systems";
      };

      flake-utils = {
        url = "github:numtide/flake-utils";
        inputs.systems.follows = "systems";
      };

      # add git hooks to format nix code before commit
      pre-commit-hooks = {
        url = "github:cachix/git-hooks.nix";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.flake-compat.follows = "flake-compat";
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
        inputs.home-manager.follows = "home-manager";
        inputs.systems.follows = "systems";
      };

      nur = {
        url = "github:nix-community/NUR"; # NUR Packages
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.flake-parts.follows = "flake-parts";
        inputs.treefmt-nix.follows = "treefmt-nix";
      };

      nixos-wsl = {
        url = "github:nix-community/NixOS-WSL";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.flake-compat.follows = "flake-compat";
      };

      nix-vscode-extensions = {
        url = "git+https://github.com/nix-community/nix-vscode-extensions?shallow=1&ref=master";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
        inputs.flake-utils.follows = "flake-utils";
      };

      emacs-overlay = {
        url = "github:nix-community/emacs-overlay/master";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.nixpkgs-stable.follows = "nixpkgs-stable";
      };


      nixvim = {
        url = "github:nix-community/nixvim";
        inputs.flake-parts.follows = "flake-parts";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      doom-config = {
        url = "github:klchen0112/doom";
        # url = "git+file:///Users/klchen/my/doom";
        flake = false;
      };

      nix-doom-emacs-unstraightened = {
        url = "github:marienz/nix-doom-emacs-unstraightened";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.systems.follows = "systems";
        inputs.emacs-overlay.follows = "emacs-overlay";
      };

      nixos-cosmic = {
        url = "github:lilyinstarlight/nixos-cosmic";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.nixpkgs-stable.follows = "nixpkgs-stable";
        inputs.flake-compat.follows = "flake-compat";
        inputs.rust-overlay.follows = "rust-overlay";
      };
      # theme
      stylix = {
        url = "github:danth/stylix";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "home-manager";
        inputs.git-hooks.follows = "pre-commit-hooks";
        inputs.flake-compat.follows = "flake-compat";
        inputs.flake-utils.follows = "flake-utils";
        inputs.nur.follows = "nur";
        inputs.systems.follows = "systems";
      };

      # own package
      own-nur = {
        url = "github:klchen0112/nur";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      agenix-secrets = {
        url = "github:klchen0112/agenix-secrets";
        flake = false;
      };

      rust-overlay = {
        url = "github:oxalica/rust-overlay";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      zen-browser = {
        url = "github:0xc000022070/zen-browser-flake";
        # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
        # to have it up-to-date or simply don't specify the nixpkgs input
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "home-manager";
      };
    };
}
