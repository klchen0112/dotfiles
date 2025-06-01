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
  machine = flake.config.machines.mbp-m1;
  system.primaryUser = "klchen";
  nixpkgs.hostPlatform = machine.platform;
  networking.hostName = machine.hostName;
  home-manager.backupFileExtension = "nixos-unified-template-backup";

  system.stateVersion = 4;

}
