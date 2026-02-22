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
    { pkgs, lib, ... }:
    {
      hardware.nvidia = {
        open = lib.mkForce false;
        modesetting.enable = true;
        nvidiaSettings = true;
        # 电源管理，开启它可以防止睡眠唤醒后的黑屏或掉驱动问题
        powerManagement.enable = false;
        # 细粒度电源管理（仅限 Turing 架构及以后的显卡，如 RTX 系列）
        powerManagement.finegrained = false;
      };
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
        font

        k3s
        k3s-node
        k3s-nvidia
      ])
      ++ (builtins.map (
        user: inputs.self.modules.nixos.${user}
      ) config.flake.meta.machines.${machine}.users);

      home-manager.users.klchen.imports = with config.flake.modules.homeManager; [
        bash
      ];
    };
}
