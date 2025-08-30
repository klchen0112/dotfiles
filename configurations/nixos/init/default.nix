{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  machine = flake.config.machines.init;
in
{
  imports = [
    flake.inputs.self.nixosModules.default
      flake.inputs.disko.nixosModules.disko
    ./disko.nix
    ./hardware-configuration.nix
  ];

  machine = machine;
  nixpkgs.hostPlatform = machine.platform;
  networking.hostName = machine.hostName;

  system.stateVersion = "25.11";
  myusers = machine.users;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;

  # networking
  networking.useNetworkd = lib.mkForce true;
  networking.useDHCP = lib.mkForce false;

  users.users.root.initialHashedPassword = "$6$vUVEcVjGo5f36ZaT$./Uh58JYMKNDgQwFWOjYZSEuXS4kyu/x1RCqF1TW8wVq3F6wVeoR5TwGgRW5rUNQZCVAYgRDCACFYlAMWfaOZ1";
  environment.systemPackages = with pkgs; [
    just
    git
    neovim
    pciutils
  ];

  # Don't allow mutation of users outside of the config.
  users.mutableUsers = false;
  zramSwap.enable = true;
}
