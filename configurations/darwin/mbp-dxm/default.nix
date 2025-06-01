{ flake, ... }:
let machine =
  flake.config.machines.mbp-dxm;
in {
  machine = flake.config.machines.machine;
  nixpkgs.hostPlatform = machine.platform;
  networking.hostName = machine.hostName;

  imports = [
    flake.inputs.self.darwinModules.default
  ];
  myusers = machine.users;
  system.primaryUser = head machine.users;
  home-manager.backupFileExtension = "nixos-unified-template-backup";

  system.stateVersion = 4;

}
