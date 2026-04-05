let
  machine = "i12400";
in
{ inputs, den, ... }:
{

  #   sshKey = [    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3hO4yhyrO8JHbP6yokAEbRDPb4FR/bhtoIb2rIBP5q root@i12r20"];
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
          hardware.graphics = {
            enable = true;
            extraPackages = with pkgs; [
              intel-media-driver # 适用于 Broadwell (第5代) 及更新的硬件
            ];
          };
          boot.initrd.kernelModules = [ "i915" ];
          boot.kernelParams = [ "i915.force_probe=*" ];

          # 2. 指定使用 modesetting 驱动 (Intel 推荐方案)
          services.xserver.videoDrivers = [ "modesetting" ];

          stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
          networking.hostName = "${machine}";

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
