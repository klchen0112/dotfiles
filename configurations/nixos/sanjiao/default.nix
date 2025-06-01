{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.default
    ./hardware-configuration.nix
  ];

  # Defined by /modules/home/me.nix
  myusers = [ "klchen" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.sudo.wheelNeedsPassword = true; # User does not need to give password when using sudo.

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "sanjiao";
  system.stateVersion = "25.11";
}
