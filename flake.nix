{
  description = "My Personal NixOS and Darwin System Flake Configuration";
  nixConfig = {
    substituters = [
      # replace official cache with a mirror located in China
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=0"
      "https://mirror.sjtu.edu.cn/nix-channels/store?priority=1"
      "https://nix-community.cachix.org?priority=2"
      "https://klchen0112.cachix.org?priority=3"
      "https://niri.cachix.org?priority=4"
      "https://cache.nixos.org?priority=5"
    ];
    trusted-substituters = [
      # replace official cache with a mirror located in China
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://niri.cachix.org"
      "https://klchen0112.cachix.org"

    ];
    trusted-public-keys = [
      "klchen0112.cachix.org-1:cO5Ek4gcvoWtHslHjWn9U5ymU8ZiN7+tJo0jifbtRz4="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };
  outputs =
    inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      imports = (
        with builtins; map (fn: ./modules/flake-parts/${fn}) (attrNames (readDir ./modules/flake-parts))
      );
    };
  inputs =
    # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=nixos-unstable"; # Nix Packages
      nixpkgs-unstable.url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=nixos-unstable-small"; # Nix Packages
      nixpkgs-stable.url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=release-25.05"; # Nix Packages

      srvos = {
        url = "github:nix-community/srvos";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      #  MacOS
      nix-darwin = {
        url = "github:LnL7/nix-darwin"; # MacOS Package Management
        inputs.nixpkgs.follows = "nixpkgs";
      };

      brew-nix = {
        url = "github:BatteredBunny/brew-nix";
        inputs.nix-darwin.follows = "nix-darwin";
        inputs.brew-api.follows = "brew-api";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      brew-api = {
        url = "github:BatteredBunny/brew-api";
        flake = false;
      };

      mac-app-util = {
        url = "github:hraban/mac-app-util";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.systems.follows = "systems";
        inputs.flake-compat.follows = "flake-compat";
      };

      # Home Manager
      home-manager = {
        # User Package Management
        url = "git+https://github.com/nix-community/home-manager?shallow=1&ref=master";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Android
      nix-on-droid = {
        url = "git+https://github.com/nix-community/nix-on-droid?shallow=1&ref=master";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "home-manager";
      };
      nixos-hardware.url = "github:NixOS/nixos-hardware/master";
      disko = {
        url = "github:nix-community/disko/latest";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      systems.url = "github:nix-systems/default";

      devshell = {
        url = "github:numtide/devshell";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      flake-utils = {
        url = "github:numtide/flake-utils";
        inputs.systems.follows = "systems";
      };

      # add git hooks to format nix code before commit
      git-hooks = {
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
        inputs.darwin.follows = "nix-darwin";
        inputs.home-manager.follows = "home-manager";
        inputs.systems.follows = "systems";
      };

      nur = {
        url = "github:nix-community/NUR"; # NUR Packages
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.flake-parts.follows = "flake-parts";
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

      niri = {
        url = "github:sodiboo/niri-flake";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.nixpkgs-stable.follows = "nixpkgs-stable";
      };
      #
      niri-caelestia-shell = {
        url = "github:jutraim/niri-caelestia-shell";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      DankMaterialShell = {
        url = "github:AvengeMedia/DankMaterialShell";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # theme
      stylix = {
        url = "github:danth/stylix";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.flake-parts.follows = "flake-parts";
        inputs.nur.follows = "nur";
        inputs.systems.follows = "systems";
      };

      zen-browser = {
        url = "github:0xc000022070/zen-browser-flake";
        # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
        # to have it up-to-date or simply don't specify the nixpkgs input
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "home-manager";
      };

      nix-index-database = {
        url = "github:nix-community/nix-index-database";
        inputs.nixpkgs.follows = "nixpkgs";
      };

    };

}
