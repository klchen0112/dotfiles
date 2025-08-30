{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  machine = flake.config.machines.a99r50;
in
{
  imports = [
    flake.inputs.self.nixosModules.default
    flake.inputs.self.nixosModules.nvidia
    flake.inputs.self.nixosModules.desktop
    flake.inputs.self.nixosModules.access-tokens
    flake.inputs.nixos-hardware.nixosModules.common-gpu-amd
    flake.inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
    flake.inputs.nixos-hardware.nixosModules.common-cpu-amd-raphael-igpu
    flake.inputs.nixos-hardware.nixosModules.common-gpu-nvidia
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
    neovim
    pciutils
  ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      # your Open GL, Vulkan and VAAPI drivers
      #	     vpl-gpu-rt # for newer GPUs on NixOS >24.05 or unstable
      # onevpl-intel-gpu  # for newer GPUs on NixOS <= 24.05
      # intel-media-sdk   # for older GPUs
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };
  services.xserver.videoDrivers = [
    "amdgpu" # example for Intel iGPU; use "amdgpu" here instead if your iGPU is AMD
    "nvidia"
  ];

  # Don't allow mutation of users outside of the config.
  users.mutableUsers = false;
  # machine-id is used by systemd for the journal, if you don't
  # persist this file you won't be able to easily use journalctl to
  # look at journals for previous boots.
  users.users."klchen".extraGroups = [
    "video"
    "render"
  ];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true; # 不需要图形控制面板
    prime = {
      offload = {
        enable = true; # 禁用 PRIME 渲染卸载

        enableOffloadCmd = true;
      };
      sync.enable = false; # 禁用 PRIME 同步
      #	      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:12:0:0";
    };
  };
  zramSwap.enable = true;
}
