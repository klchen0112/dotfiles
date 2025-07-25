{ flake, ... }:
let
  machine = flake.config.machines.sanjiao;
in
{
  imports = [
    flake.inputs.self.nixosModules.default
    flake.inputs.self.nixosModules.server
    ./hardware-configuration.nix
  ];
  machine = machine;
  nixpkgs.hostPlatform = machine.platform;
  networking.hostName = machine.hostName;
  # Defined by /modules/home/me.nix
  myusers = machine.users;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  system.stateVersion = "25.11";
}
