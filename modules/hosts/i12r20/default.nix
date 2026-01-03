{ inputs, config, ... }:
{
  flake.meta.machines.i12r20 = {

    hostName = "i12r20";
    platform = "x86_64-linux";
    base16Scheme = "selenized-light";
    sshKey = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3hO4yhyrO8JHbP6yokAEbRDPb4FR/bhtoIb2rIBP5q root@i12r20"
    ];
    users = [
      "klchen"
    ];
    desktop = true;
  };
  flake.modules.nixos.i12r20 =
    {
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.klchen
        inputs.self.modules.nixos.font
        inputs.self.modules.nixos.access-tokens
        inputs.self.modules.nixos.vm
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        # offload
        inputs.nixos-hardware.nixosModules.common-pc-ssd
      ];
      home-manager.users.klchen.imports = with config.flake.modules.homeManager; [
        access-tokens
      ];
      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      networking.networkmanager.enable = true;

      environment.systemPackages = with pkgs; [
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
    };
}
