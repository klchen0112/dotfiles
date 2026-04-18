let
  machine = "a2700";
in
{
  inputs,
  den,
  ...
}:
{
  #   sshKey = [      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsw5gk6koAb2D1SYnHt3jhYLNCWChR6eFKJ3vPO3tZY"];
  den.hosts.x86_64-linux.${machine} = {
    roles = [
      "emacs-twist"
      "stylix-home"
    ];
    users = {
      klchen.roles = [
        "emacs-twist"
        "stylix-home"

      ];
    };
    klchen = { };
  };

  den.aspects.${machine} =
    { lib, ... }:
    {

      includes = with den.aspects; [
        font
        persist
        k3s
        k3s-node
        stylix

      ];
      nixos =
        {
          pkgs,
          ...
        }:
        {
          networking.hostName = "${machine}";

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

          stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";

          # Bootloader.
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
          networking.networkmanager.enable = true;
          environment.systemPackages = with pkgs; [
            clinfo
            mesa-demos
          ];
          imports = [
            inputs.nixos-hardware.nixosModules.common-cpu-amd
            inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
            # offload
            inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
            inputs.nixos-hardware.nixosModules.common-pc-ssd
          ];

          # Don't allow mutation of users outside of the config.
          # machine-id is used by systemd for the journal, if you don't
          # persist this file you won't be able to easily use journalctl to
        };
    };

}
