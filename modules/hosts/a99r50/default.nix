let
  machine = "a99r50";
in
{ inputs, den, ... }:
{

  den.hosts.x86_64-linux.${machine} = {
    roles = [
      "stylix-home"
      "emacs-twist"
      "ghostty"
      "kitty"
      "inputmethod"
      "zen"
      "zsh"
      "python"
      "syncthing"
      "aria2"
      "llm"
      "noctalia-shell"
      "niri-home"
    ];
    users.klchen = {
       roles = [
      "stylix-home"
      "emacs-twist"
      "ghostty"
      "kitty"
      "inputmethod"
      "zen"
      "zsh"
      "python"
      "syncthing"
      "aria2"
      "llm"
      "noctalia-shell"
      "niri-home"
    ];
     };
    users.root = { };
  };

  den.aspects.${machine} = {
    nixos =
      { pkgs, ... }:
      {
        boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto-zen4;

        imports = [
          inputs.nixos-hardware.nixosModules.common-cpu-amd
          inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
          inputs.nixos-hardware.nixosModules.common-cpu-amd-raphael-igpu
          # offload
          inputs.nixos-hardware.nixosModules.common-gpu-nvidia
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          inputs.nixos-hardware.nixosModules.common-hidpi
          inputs.srvos.nixosModules.mixins-terminfo
        ];
        hardware.nvidia.primeBatterySaverSpecialisation = true;
        # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
        boot.kernelParams = [
          # Since NVIDIA does not load kernel mode setting by default,
          # enabling it is required to make Wayland compositors function properly.
          "nvidia-drm.fbdev=1"
        ];
        networking.hostName = "${machine}";
        # Bootloader.
        boot.loader.systemd-boot.enable = true;
        environment.systemPackages = with pkgs; [
          pciutils
          git
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

        # Don't allow mutation of users outside of the config.
        users.mutableUsers = false;

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
        users.users.klchen.isNormalUser = true;
      };
    includes =
      with den.aspects;
      [
        font
        # keyboard
        flatpak
        k3s
        k3s-node
        k3s-nvidia
        nvidia
        niri
        noctalia-shell
        # stylix
        emacs-twist
        persist
        nix
      ]
      ++ [

        (den.provides.tty-autologin "klchen")

      ];
  };
  #  flake.meta.machines.${machine} = {
  #    sshKey = [
  #      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHRBuSM5DLKYUtS1gmoZEA+y2xGrWWtxs3HEutD1LCwx"
  #    ];
  #  };
  #  den.aspects.nixos.${machine} =
  #    {
  #      pkgs,
  #      lib,
  #      ...
  #    }:
  #    {
  #
  #
  #      # Bootloader.
  #      # Load nvidia driver for Xorg and Wayland
  #      hardware.graphics = {
  #        enable = true;
  #        enable32Bit = true;
  #        extraPackages = with pkgs; [
  #          libva-vdpau-driver
  #          libvdpau-va-gl
  #          vulkan-loader
  #          vulkan-headers
  #          nvidia-vaapi-driver
  #          mesa
  #          vulkan-tools
  #          vulkan-validation-layers
  #          # your Open GL, Vulkan and VAAPI drivers
  #          #	     vpl-gpu-rt # for newer GPUs on NixOS >24.05 or unstable
  #          # onevpl-intel-gpu  # for newer GPUs on NixOS <= 24.05:
  #          # intel-media-sdk   # for older GPUs
  #        ];
  #      };
  #
  #      # Don't allow mutation of users outside of the config.
  #      users.mutableUsers = false;
  #      # machine-id is used by systemd for the journal, if you don't
  #      # persist this file you won't be able to easily use journalctl to
  #      # look at journals for previous boots.
  #      networking.networkmanager.enable = true;
  #      # These options are unnecessary when managing DNS ourselves
  #      networking.interfaces.eno1 = {
  #        useDHCP = true;
  #        wakeOnLan.enable = true;
  #      };
  #      networking = {
  #        resolvconf.enable = true;
  #        # 清空所有静态 DNS 配置
  #        nameservers = [ ];
  #
  #        # 可选：确保 DHCP 的 DNS 优先级最高
  #        dhcpcd.extraConfig = "nohook resolv.conf";
  #      };
  #
  #    };
}
