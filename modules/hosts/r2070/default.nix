let
  machine = "r2070";
in
{
  inputs,
  config,
  ...
}:
{
  flake.meta.machines.${machine} = {

    hostName = "${machine}";
    platform = "x86_64-linux";
    sshKey = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsw5gk6koAb2D1SYnHt3jhYLNCWChR6eFKJ3vPO3tZY"
    ];
    base16Scheme = "selenized-light";
    users = [ "klchen" ];
  };
  flake.modules.nixos.${machine} =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages;
      hardware.nvidia = {
        open = false;
        modesetting.enable = true;
        nvidiaSettings = true;
        prime.nvidiaBusId = "PCI:10:0:0";
        # 电源管理，开启它可以防止睡眠唤醒后的黑屏或掉驱动问题
        powerManagement.enable = false;
        # 细粒度电源管理（仅限 Turing 架构及以后的显卡，如 RTX 系列）
        powerManagement.finegrained = false;
      };
      boot.kernelParams = [
        "nvidia-drm.modeset=1"
        "NVreg_PreserveVideoMemoryAllocations=1" # 辅助解决内存分配问题
        "iommu=soft"
        "video=efifb:off" # 禁用 EFI 帧缓冲
        "video=vesafb:off" # 禁用 VESA 帧缓冲
      ];
      boot.initrd.kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
      # 2. 确保没有加载开源驱动且强制加载闭源驱动
      boot.blacklistedKernelModules = [ "nouveau" ];
      # Enable OpenGL
      hardware.graphics = {
        enable = true;
      };


      # Load nvidia driver for Xorg and Wayland
      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
        # offload
        inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        inputs.nixos-hardware.nixosModules.common-pc-ssd
      ]
      ++ (with inputs.self.modules.nixos; [
      ])
      ++ (builtins.map (user: inputs.self.modules.nixos.${user}) config.flake.meta.machines.r2070.users);

      home-manager.users.klchen.imports = with config.flake.modules.homeManager; [
        ghostty
        aria2
        bash
        syncthing
      ];
    };
}
