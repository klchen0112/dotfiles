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
    flake.inputs.self.nixosModules.access-tokens
  ];
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
  environment.systemPackages = with pkgs; [
    cudatoolkit
    vulkan-tools
    clinfo
    glxinfo
    intel-gpu-tools
  ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # your Open GL, Vulkan and VAAPI drivers
      vpl-gpu-rt # for newer GPUs on NixOS >24.05 or unstable
      # onevpl-intel-gpu  # for newer GPUs on NixOS <= 24.05
      # intel-media-sdk   # for older GPUs
    ];
  };
  services.xserver.videoDrivers = [
    "modesetting" # example for Intel iGPU; use "amdgpu" here instead if your iGPU is AMD
    "nvidia"
  ];
  boot.kernelParams = [
    "i915.force_probe=4692"
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
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  hardware.nvidia-container-toolkit.enable = true;
}
