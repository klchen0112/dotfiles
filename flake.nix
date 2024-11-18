{
  description = "My Personal NixOS and Darwin System Flake Configuration";
  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    substituters = [
      # replace official cache with a mirror located in China
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
      "https://cosmic.cachix.org/"
    ];
    extra-substituters = [
      "https://anyrun.cachix.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://ruixi-rebirth.cachix.org"
      "https://klchen0112.cachix.org"
      "https://devenv.cachix.org"
      "https://rycee.cachix.org"
    ];
    extra-trusted-public-keys = [
      "klchen0112.cachix.org-1:cO5Ek4gcvoWtHslHjWn9U5ymU8ZiN7+tJo0jifbtRz4="
      "ryan4yin.cachix.org-1:Gbk27ZU5AYpGS9i3ssoLlwdvMIh0NxG0w8it/cv9kbU="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "ruixi-rebirth.cachix.org-1:sWs3V+BlPi67MpNmP8K4zlA3jhPCAvsnLKi4uXsiLI4="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "rycee.cachix.org-1:TiiXyeSk0iRlzlys4c7HiXLkP3idRf20oQ/roEUAh/A="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
    ];
    trusted-users = ["root" "@wheel" "chenkailong_dxm" "klchen"];
  };

  outputs = inputs @ {
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
      in
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs username outputs;};
          modules = [
            ./machines/i12500
            inputs.agenix.nixosModules.default
            inputs.nixos-cosmic.nixosModules.default
          ];
        };
    };
    homeConfigurations = {
      "klchen@i12500" = let
        username = "klchen";
        isWork = false;
      in
        home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {inherit inputs outputs username isWork;};
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
            inputs.brew-nix.darwinModules.default
            inputs.agenix.darwinModules.default
          ];
        };
      "mbp-dxm" = let
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
            ./machines/mbp-dxm
            home-manager.darwinModules.home-manager
            {
              # Home-Manager module that is used
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit username userEmail inputs outputs isWork;
              }; # Pass flake variable
              home-manager.users.${username} =
                import ./hosts/mbp-dxm/default.nix;
            }
            inputs.brew-nix.darwinModules.default
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
      nixpkgs-unstable.url = "github:nixos/nixpkgs/master"; # Nix Packages

      #  MacOS
      darwin = {
        url = "github:lnl7/nix-darwin/master"; # MacOS Package Management
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
        url = "github:klchen0112/home-manager/emacs";
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
        inputs.systems.follows = "systems";
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
      };

      # doomemacs = {
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
      doom = {
        url = "github:klchen0112/doom";
        flake = false;
      };

      nix-doom-emacs-unstraightened = {
        url = "github:marienz/nix-doom-emacs-unstraightened";
        # Optional, to download less. Neither the module nor the overlay uses this input.
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.systems.follows = "systems";
        inputs.emacs-overlay.follows = "emacs-overlay";
        # inputs.doomemacs.follows = "doomemacs";
      };

      nixos-cosmic = {
        url = "github:lilyinstarlight/nixos-cosmic";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.flake-compat.follows = "flake-compat";
      };

      anyrun = {
        url = "github:Kirottu/anyrun";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.flake-parts.follows = "flake-parts";
        inputs.systems.follows = "systems";
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
