{ inputs, ... }:
{
  flake-file.inputs = {

  };
  flake.modules.nixos.vm =
    { modulesPath, ... }:
    {
      ###################################################################################
      #
      #  Visualisation - Libvirt(QEMU/KVM) / Docker / LXD / WayDroid
      #
      ###################################################################################
      imports = [
      ];
      virtualisation = {
        docker = {
          enable = true;
          daemon.settings = {
            # enables pulling using containerd, which supports restarting from a partial pull
            # https://docs.docker.com/storage/containerd/
            "features" = {
              "containerd-snapshotter" = true;
            };
          };

          # start dockerd on boot.
          # This is required for containers which are created with the `--restart=always` flag to work.
          enableOnBoot = true;
        };

        waydroid.enable = true;
      };

    };
  flake.modules.homeManager.vm =
    { pkgs, ... }:
    {

      home.packages = with pkgs; [
        colima
        lima
      ];
    };
}
