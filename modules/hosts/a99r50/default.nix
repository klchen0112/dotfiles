let
  machine = "a99r50";
in
{ inputs, config, ... }:
{
  flake.meta.machines.${machine} = {
    hostName = "${machine}";
    platform = "x86_64-linux";
    base16Scheme = "selenized-light";
    sshKey = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHRBuSM5DLKYUtS1gmoZEA+y2xGrWWtxs3HEutD1LCwx"
    ];
    users = [
      "klchen"
    ];
    desktop = true;
  };
  flake.modules.nixos.${machine} =
    {
      pkgs,
      lib,
      ...
    }:
    {

      home-manager.users.klchen.imports = with config.flake.modules.homeManager; [
        inputmethod
        niri
        noctalia-shell
        ghostty
        aria2
        kitty
        bash
        syncthing
        emacs-twist
        zen
        # chrome
        # access-tokens
        # keyboard
        vscode
        flatpak
        im
        office
        latex
      ];
      home-manager.backupFileExtension = "hmbp";

      imports = [
        inputs.self.modules.nixos.flatpak
        # inputs.self.nixosModules.nvidia
        # inputs.self.modules.nixos.nvidia

        inputs.self.modules.nixos.font
        inputs.self.modules.nixos.niri
        # inputs.self.modules.nixos.access-tokens
        inputs.self.modules.nixos.noctalia-shell

        inputs.self.modules.nixos.vm
        inputs.self.modules.nixos.keyboard

        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
        inputs.nixos-hardware.nixosModules.common-cpu-amd-raphael-igpu
        # offload
        inputs.nixos-hardware.nixosModules.common-gpu-nvidia
        inputs.nixos-hardware.nixosModules.common-pc-ssd
        inputs.nixos-hardware.nixosModules.common-hidpi
        inputs.disko.nixosModules.disko

      ]
      ++ (builtins.map (
        user: inputs.self.modules.nixos.${user}
      ) config.flake.meta.machines.${machine}.users);
      boot.kernelParams = [
        # Since NVIDIA does not load kernel mode setting by default,
        # enabling it is required to make Wayland compositors function properly.
        "nvidia-drm.fbdev=1"
      ];

      services.xserver.enable = true;
      services.hardware.openrgb = {
        enable = true;
        package = pkgs.openrgb-with-all-plugins;
        motherboard = "amd";
      };

      # boot.kernelPackages = pkgs.linuxPackages_latest;

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      environment.systemPackages = with pkgs; [
        pciutils
      ];
      # Load nvidia driver for Xorg and Wayland
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          libva-vdpau-driver
          libvdpau-va-gl
          vulkan-loader
          vulkan-headers
          nvidia-vaapi-driver
          mesa
          vulkan-tools
          vulkan-validation-layers
          # your Open GL, Vulkan and VAAPI drivers
          #	     vpl-gpu-rt # for newer GPUs on NixOS >24.05 or unstable
          # onevpl-intel-gpu  # for newer GPUs on NixOS <= 24.05:
          # intel-media-sdk   # for older GPUs
        ];
      };
      services.xserver.videoDrivers = [
        # "amdgpu" # example for Intel iGPU; use "amdgpu" here instead if your iGPU is AMD
        "nvidia"
      ];

      # Don't allow mutation of users outside of the config.
      users.mutableUsers = false;
      # machine-id is used by systemd for the journal, if you don't
      # persist this file you won't be able to easily use journalctl to
      # look at journals for previous boots.
      hardware.nvidia-container-toolkit.enable = true;
      hardware.nvidia = {
        modesetting.enable = true;
        nvidiaSettings = true;
        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
        # of just the bare essentials.
        powerManagement.enable = false;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = false;
        open = true; # tried both
        prime = {
          # offload = {
          #   enable = true; # 禁用 PRIME 渲染卸载
          #   enableOffloadCmd = true;
          # };
          # sync.enable = true; # 禁用 PRIME 同步
          #	      intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";
          amdgpuBusId = "PCI:12:0:0";
        };
      };
      zramSwap.enable = true;
      networking.networkmanager.enable = true;
      # These options are unnecessary when managing DNS ourselves
      networking.interfaces.eno1 = {
        useDHCP = true;
        wakeOnLan.enable = true;
      };
      networking = {
        resolvconf.enable = true;
        # 清空所有静态 DNS 配置
        nameservers = [ ];

        # 可选：确保 DHCP 的 DNS 优先级最高
        dhcpcd.extraConfig = "nohook resolv.conf";
      };

      environment.etc = {
        "machine-id".source = "/nix/persist/etc/machine-id";
        "ssh/ssh_host_rsa_key".source = "/nix/persist/etc/ssh/ssh_host_rsa_key";
        "ssh/ssh_host_rsa_key.pub".source = "/nix/persist/etc/ssh/ssh_host_rsa_key.pub";
        "ssh/ssh_host_ed25519_key".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
        "ssh/ssh_host_ed25519_key.pub".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key.pub";
      };
    };
}
