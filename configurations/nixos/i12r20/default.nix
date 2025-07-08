{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  machine = flake.config.machines.i12r20;
in
{
  imports = [
    flake.inputs.self.nixosModules.default
    flake.inputs.self.nixosModules.nvidia
    flake.inputs.self.nixosModules.desktop
    ./hardware-configuration.nix
    flake.inputs.nixos-facter-modules.nixosModules.facter
  ];
  facter.reportPath = ./facter.json;
  machine = machine;
  nixpkgs.hostPlatform = machine.platform;
  networking.hostName = machine.hostName;

  system.stateVersion = "25.05";
  myusers = machine.users;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;

  users.users.root.initialHashedPassword = "$6$vUVEcVjGo5f36ZaT$./Uh58JYMKNDgQwFWOjYZSEuXS4kyu/x1RCqF1TW8wVq3F6wVeoR5TwGgRW5rUNQZCVAYgRDCACFYlAMWfaOZ1";
  services.xserver.videoDrivers = [
    "modesetting" # example for Intel iGPU; use "amdgpu" here instead if your iGPU is AMD
    "nvidia"
  ];

  # Don't allow mutation of users outside of the config.
  users.mutableUsers = false;
  # machine-id is used by systemd for the journal, if you don't
  # persist this file you won't be able to easily use journalctl to
  # look at journals for previous boots.
  environment.etc = {
    "machine-id".source = "/nix/persist/etc/machine-id";
    "ssh/ssh_host_rsa_key".source = "/nix/persist/etc/ssh/ssh_host_rsa_key";
    "ssh/ssh_host_rsa_key.pub".source = "/nix/persist/etc/ssh/ssh_host_rsa_key.pub";
    "ssh/ssh_host_ed25519_key".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
    "ssh/ssh_host_ed25519_key.pub".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key.pub";
  };
  hardware.nvidia.prime = {
    reverseSync.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
