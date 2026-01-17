{
  self,
  inputs,
  lib,
  ...
}:
let
  inherit (inputs.self.lib.mk-os)
    darwin
    linux
    wsl
    mkNode
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
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.darwinConfigurations = {
    mbp-m1 = darwin "mbp-m1";
  };
  flake.nixosConfigurations = {
    a99r50 = linux "a99r50";
    i12r20 = linux "i12r20";
    sanjiao = linux "sanjiao";
    wsl-nixos = wsl "wsl-nixos";
    init = linux "init";
  };
  flake.deploy = {
    nodes = {
      a99r50 = mkNode "a99r50" self.nixosConfigurations.a99r50;
      sanjiao = mkNode "sanjiao" self.nixosConfigurations.sanjiao;
    };
  };
}
