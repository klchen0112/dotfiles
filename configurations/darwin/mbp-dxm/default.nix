{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  machine = flake.config.machines.mbp-m1;
  nixpkgs.hostPlatform = machine.platform;
  networking.hostName = machine.hostName;

  imports = [
    self.darwinModules.default
  ];
  myusers = [
    "chenkailong_dxm"
  ];
  system.primaryUser = "chenkailong_dxm";
  home-manager.backupFileExtension = "nixos-unified-template-backup";

  system.stateVersion = 4;

}
