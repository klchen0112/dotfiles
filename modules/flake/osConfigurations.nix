{ inputs, ... }:
let
  inherit (inputs.self.lib.mk-os)
    darwin
    linux
    ;
in
{
  flake-file.inputs = {
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.darwinConfigurations = {
    mbp-m1 = darwin "mbp-m1";
  };
  flake.nixosConfigurations = {
    a99r50 = linux "a99r50";
    init = linux "init";
  };
}
