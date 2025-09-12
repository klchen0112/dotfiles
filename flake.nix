{
  description = "My Personal NixOS and Darwin System Flake Configuration";
  nixConfig = {
    allow-import-from-derivation = true;
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
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
  inputs =
    # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs = {
        url = "github:nixos/nixpkgs/nixpkgs-unstable";
      };
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
    };

}
