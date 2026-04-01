let
  machine = "i12r20";
in
{ inputs, ... }:
{

  #   sshKey = [    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3hO4yhyrO8JHbP6yokAEbRDPb4FR/bhtoIb2rIBP5q root@i12r20"];
  den.hosts.x86-64-linux.${machine} = {
    klchen = { };
  };

  den.aspects.${machine} =
    { den, lib, ... }:
    {
      den.hosts.x86_64-linux.${machine} = {
        roles = [
          "emacs-twist"
        ];
        users = {
          klchen.roles = [
            "emacs-twist"

          ];
        };
      };

      includes = with den.aspects; [
        font
        persist
        k3s-master
        stylix
      ];
      nixos =
        {
          pkgs,
          ...
        }:
        {
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
          hardware.graphics = {
            enable = true;
          };

          # Don't allow mutation of users outside of the config.
          # machine-id is used by systemd for the journal, if you don't
          # persist this file you won't be able to easily use journalctl to
        };
    };
}
