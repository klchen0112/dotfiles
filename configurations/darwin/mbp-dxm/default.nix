# Configuration for my M1 Macbook Max as headless server
{ flake, ... }:
let
  machine = flake.config.machines.mbp-dxm;
  myusers = machine.users;
  primaryUser = builtins.head machine.users;
  platform = machine.platform;
  hostName = machine.hostName;
in
{
  imports = [
    flake.inputs.self.darwinModules.default
  ];
  inherit machine myusers;
  system.primaryUser = primaryUser;
  nixpkgs.hostPlatform = platform;
  networking.hostName = hostName;
  home-manager.backupFileExtension = "nixos-unified-template-backup";

  system.stateVersion = 4;

}
