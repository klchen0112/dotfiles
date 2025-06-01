# Configuration for my M1 Macbook Max as headless server
{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
rec {

  imports = [
    self.darwinModules.default
  ];
  myusers = [
    "klchen"
  ];
  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "mbp-m1";
  home-manager.backupFileExtension = "nixos-unified-template-backup";

  system.stateVersion = "24.11";

}
