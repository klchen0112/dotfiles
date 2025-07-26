# Configuration for my M1 Macbook Max as headless server
{ flake, lib, ... }:
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
  ]
  ++ (lib.optionals machine.desktop [
    flake.inputs.self.darwinModules.desktop
  ]);
  inherit machine myusers;
  system.primaryUser = primaryUser;
  nixpkgs.hostPlatform = platform;
  networking.hostName = hostName;

  system.stateVersion = 4;
  ids.gids.nixbld = 350;
  system.defaults.NSGlobalDomain._HIHideMenuBar = false;
}
