{
  description = "My Personal NixOS and Darwin System Flake Configuration";
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
  inputs =
    # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/master";
      nixpkgs-stable.url = "github:nixos/nixpkgs/release-25.05";

      srvos = {
        url = "github:nix-community/srvos";
      };

      allfollow = {
        url = "github:spikespaz/allfollow";
      };

      # Android
      nix-on-droid = {
        url = "git+https://github.com/nix-community/nix-on-droid?shallow=1&ref=master";
      };
      nixos-hardware.url = "github:NixOS/nixos-hardware/master";
      disko = {
        url = "github:nix-community/disko/latest";
      };
      agenix.url = "github:ryantm/agenix";
      emacs-overlay.url = "github:nix-community/emacs-overlay/master";

      # add git hooks to format nix code before commit
      git-hooks = {
        url = "github:cachix/git-hooks.nix";
      };
      dendrix.url = "github:vic/dendrix";

      treefmt-nix = {
        url = "github:numtide/treefmt-nix";
      };

      flake-parts = {
        url = "github:hercules-ci/flake-parts";
      };
      import-tree.url = "github:vic/import-tree";
      flake-file = {
        url = "github:vic/flake-file";
      };
      devshell = {
        url = "github:numtide/devshell";
      };
      home-manager = {
        url = "github:nix-community/home-manager";
      };
      nur = {
        url = "github:nix-community/NUR"; # NUR Packages
      };

      nixos-wsl = {
        url = "github:nix-community/NixOS-WSL";
      };
      systems = {
        url = "github:nix-systems/default";
      };
      pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
      nix-darwin = {
        url = "github:LnL7/nix-darwin"; # MacOS Package Management
      };
      nix-doom-emacs-unstraightened.url = "github:marienz/nix-doom-emacs-unstraightened";

      doom-config = {
        url = "github:klchen0112/doom";
        # url = "git+file:///Users/klchen/my/doom";
        flake = false;
      };
      nix-vscode-extensions = {
      url = "git+https://github.com/nix-community/nix-vscode-extensions?shallow=1&ref=master";
    };
    };

}
