let
  machine = "sanjiao";
in

{ inputs, den, ... }:
{

  den.hosts.x86_64-linux.${machine} = {
    roles = [
      "stylix-home"

    ];
    users = {
      klchen.roles = [
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
        k3s
        k3s-master
        k3s-master-init
        stylix
      ];
      nixos =
        {
          pkgs,
          ...
        }:
        {
          # 1. 开启硬件图形支持
          hardware.graphics = {
            enable = true;
            extraPackages = with pkgs; [
              intel-media-driver # 适用于 Broadwell (第5代) 及更新的硬件
            ];
          };

          # 2. 指定使用 modesetting 驱动 (Intel 推荐方案)
          services.xserver.videoDrivers = [ "modesetting" ];
          networking.hostName = "${machine}";
          boot.kernelPackages = pkgs.linuxPackages;

          stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";

          imports = [
            inputs.nixos-hardware.nixosModules.common-cpu-intel
            # offload
            inputs.nixos-hardware.nixosModules.common-pc-ssd
          ];
          hardware.intelgpu.vaapiDriver = "intel-media-driver";
          # Bootloader.
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
          networking.networkmanager.enable = true;
          environment.systemPackages = with pkgs; [
            clinfo
            mesa-demos
          ];

          # Don't allow mutation of users outside of the config.
          # machine-id is used by systemd for the journal, if you don't
          # persist this file you won't be able to easily use journalctl to
        };
    };
}

#     sshKey = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID8T9wyRN9CA/wWN70aHaRoAi1BRFeWkIjfL6+sycRaI" ];
