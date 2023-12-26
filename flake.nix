{
  description = "My Personal NixOS and Darwin System Flake Configuration";
  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    substituters = [
      # replace official cache with a mirror located in China
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://anyrun.cachix.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://ruixi-rebirth.cachix.org"
      "https://ryan4yin.cachix.org"
    ];
    extra-trusted-public-keys = [
      "ryan4yin.cachix.org-1:Gbk27ZU5AYpGS9i3ssoLlwdvMIh0NxG0w8it/cv9kbU="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "ruixi-rebirth.cachix.org-1:sWs3V+BlPi67MpNmP8K4zlA3jhPCAvsnLKi4uXsiLI4="
    ];
    trusted-users = [ "root" "@wheel" ];
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , home-manager
    , darwin
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
        in import ./pkgs { inherit pkgs inputs; }
      );
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

      # Accessible through 'nix develop' or 'nix-shell' (legacy)
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations =
        let
          username = "klchen";
        in
        {
          # NixOS configurations
          "i12500" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs username outputs;

            };
            modules = [
              # hyprland.nixosModules.default
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
      };
      darwinConfigurations =
        let username = "klchen";
        in
        {
          "macbook-pro-m1" = darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            specialArgs = {
              inherit username inputs outputs;
            };
            # pkgs = nixpkgs.legacyPackages.aarch64-darwin;
            modules = [
              # Modules that are used
              ./machines/macbook-pro-m1
              home-manager.darwinModules.home-manager
              {
                # Home-Manager module that is used
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { inherit username inputs outputs; }; # Pass flake variable
                home-manager.users.${username} = import ./hosts/macbook-pro-m1/default.nix;
              }
            ];
          };
        };
    };

  inputs =
    # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/release-23.11"; # Nix Packages
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # Nix Packages
      systems.url = "github:nix-systems/default";
      agenix = {
        url = "github:ryantm/agenix";
        inputs.darwin.follows = "darwin";
        inputs.home-manager.follows = "home-manager";
      };
      nixos-hardware = {
        url = "github:NixOS/nixos-hardware";
      };

      devshell = {
        url = "github:numtide/devshell";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.systems.follows = "systems";
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

      home-manager = {
        # User Package Management
        url = "github:nix-community/home-manager/release-23.11";
        inputs.nixpkgs.follows = "nixpkgs";
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

      nixos-wsl = {
        url = "github:nix-community/NixOS-WSL";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.flake-utils.follows = "flake-utils";
        inputs.flake-compat.follows = "flake-compat";
      };

      emacs-overlay = {
        url = "github:nix-community/emacs-overlay/master";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.nixpkgs-stable.follows = "nixpkgs-unstable";
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


      # hyprland

      nixpkgs-wayland = {
        url = "github:nix-community/nixpkgs-wayland";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.flake-compat.follows = "flake-compat";
        inputs.nix-eval-jobs.follows = "nix-eval-jobs";
        inputs.lib-aggregate.follows = "lib-aggregate";
      };

      hyprland = {
        # Official Hyprland flake
        url = "github:vaxerski/Hyprland";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.systems.follows = "systems";
      };

      hyprpaper = {
        url = "github:hyprwm/hyprpaper";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      hyprpicker = {
        url = "github:hyprwm/hyprpicker";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      hyprcontrib = {
        url = "github:hyprwm/contrib";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      anyrun = {
        url = "github:Kirottu/anyrun";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      hycov = {
        url = "github:DreamMaoMao/hycov";
        inputs.hyprland.follows = "hyprland";
      };

      # fonts
      apple-fonts = {
        url = "github:Lyndeno/apple-fonts.nix";
        inputs.flake-utils.follows = "flake-utils";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # AI


      ########################  Color Schemes  #########################################

      # color scheme - catppuccin
      catppuccin-btop = {
        url = "github:catppuccin/btop";
        flake = false;
      };

      catppuccin-fcitx5 = {
        url = "github:catppuccin/fcitx5";
        flake = false;
      };

      catppuccin-bat = {
        url = "github:catppuccin/bat";
        flake = false;
      };

      catppuccin-alacritty = {
        url = "github:catppuccin/alacritty";
        flake = false;
      };

      catppuccin-wezterm = {
        url = "github:catppuccin/wezterm";
        flake = false;
      };

      catppuccin-starship = {
        url = "github:catppuccin/starship";
        flake = false;
      };

      catppuccin-hyprland = {
        url = "github:catppuccin/hyprland";
        flake = false;
      };

      catppuccin-cava = {
        url = "github:catppuccin/cava";
        flake = false;
      };

      # own package
      rime-jd = {
        url = "github:klchen0112/RIME_JD";
        flake = false;
      };
    };



}

