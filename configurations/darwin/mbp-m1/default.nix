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
  myUsers = [
    "klchen"
  ];
  machine = flake.config.machines.mbp-m1;
  nixpkgs.hostPlatform = machine.platform;
  networking.hostName = machine.hostName;


}
