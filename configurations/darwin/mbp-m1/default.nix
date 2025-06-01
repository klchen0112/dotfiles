# Configuration for my M1 Macbook Max as headless server
{ flake, ... }:
let machine =
  flake.config.machines.mbp-m1;
in {
  imports = [
    flake.inputs.self.darwinModules.default
  ];
  myusers = machine.users;
  system.primaryUser = builtins.head machine.users;
  machine = machine;
  nixpkgs.hostPlatform = machine.platform;
  networking.hostName = machine.hostName;
  home-manager.backupFileExtension = "nixos-unified-template-backup";

  system.stateVersion = 4;

}
