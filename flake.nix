# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    DankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
    };
    agenix = {
      url = "github:ryantm/agenix";
    };
    allfollow = {
      url = "github:spikespaz/allfollow";
    };
    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
    };
    devshell = {
      url = "github:numtide/devshell";
    };
    disko = {
      url = "github:nix-community/disko";
    };
    doom-config = {
      flake = false;
      url = "github:klchen0112/doom";
    };
    doom-emacs = {
      flake = false;
      url = "github:doomemacs/doomemacs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/master";
    };
    flake-file = {
      url = "github:vic/flake-file";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
    };
    import-tree = {
      url = "github:vic/import-tree";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
    };
    nixpkgs = {
      url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=nixos-unstable";
    };
    nixpkgs-lib = {
      follows = "nixpkgs";
    };
    nixpkgs-stable = {
      url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=release-25.05";
    };
    nixpkgs-unstable = {
      url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=nixos-unstable-small";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    nur = {
      url = "github:nix-community/NUR";
    };
    pkgs-by-name-for-flake-parts = {
      url = "github:drupol/pkgs-by-name-for-flake-parts";
    };
    srvos = {
      url = "github:nix-community/srvos";
    };
    stylix = {
      url = "github:nix-community/stylix";
    };
    systems = {
      url = "github:nix-systems/default";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
    };
  };

}
