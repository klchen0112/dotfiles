{
  flake,
  pkgs,
  ...
}:
let
  machine = flake.config.machines.a3400g;
in
{
  imports = [
    flake.inputs.self.nixosModules.default
      flake.inputs.self.nixosModules.server
    ./hardware-configuration.nix
  ];
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

  machine = machine;
  nixpkgs.hostPlatform = machine.platform;
  networking.hostName = machine.hostName;

}
