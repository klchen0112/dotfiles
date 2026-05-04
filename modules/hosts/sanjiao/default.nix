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
        nix
      ];
      nixos =
        {
          pkgs,
          ...
        }:
        {
          networking.hostName = "${machine}";

          stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";

          imports = [
            inputs.nixos-hardware.nixosModules.common-cpu-intel
            # offload
            inputs.nixos-hardware.nixosModules.common-pc-ssd
            inputs.srvos.nixosModules.mixins-terminfo
          ];
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
          networking.networkmanager.enable = true;

          # Don't allow mutation of users outside of the config.
          # machine-id is used by systemd for the journal, if you don't
          # persist this file you won't be able to easily use journalctl to
          boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto;

        };
    };
}

#     sshKey = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID8T9wyRN9CA/wWN70aHaRoAi1BRFeWkIjfL6+sycRaI" ];
