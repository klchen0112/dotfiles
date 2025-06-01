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

  # Wired using https://nixos-unified.org/autowiring.html
  outputs = inputs:
    inputs.nixos-unified.lib.mkFlake
      { inherit inputs; root = ./.; };
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

      nixos-unified.url = "github:srid/nixos-unified";

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

      # nixvim = {
      #   url = "github:nix-community/nixvim";
      #   inputs.flake-parts.follows = "flake-parts";
      #   inputs.nixpkgs.follows = "nixpkgs";
      # };
      nix4nvchad = {
        url = "github:nix-community/nix4nvchad";
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
        # inputs.nixpkgs-stable.follows = "nixpkgs-stable";
        # inputs.flake-compat.follows = "flake-compat";
        # inputs.rust-overlay.follows = "rust-overlay";
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
        inputs.git-hooks.follows = "git-hooks";
        inputs.flake-compat.follows = "flake-compat";
        inputs.flake-parts.follows = "flake-parts";
        inputs.nur.follows = "nur";
        inputs.systems.follows = "systems";
      };

      # own package
      # own-nur = {
      #   url = "github:klchen0112/nur";
      #   inputs.nixpkgs.follows = "nixpkgs";
      # };

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
      omnix.url = "github:juspay/omnix";
    };

}
