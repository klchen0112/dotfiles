{ flake, ... }:
let machine =
  flake.config.machines.sanjiao;
in
 {
  imports = [
    flake.inputs.self.nixosModules.default
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

  security.sudo.wheelNeedsPassword = true; # User does not need to give password when using sudo.

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  system.stateVersion = "25.11";
}
