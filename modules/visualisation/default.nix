{ inputs, ... }:
{
  flake-file.inputs = {

  };
  den.aspects.vm.nixos =
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
        containerd = {
          enable = true;
        };
      };

    };
  den.aspects.waydroid.nixos =
    { modulesPath, ... }:
    {
      ###################################################################################
      #
      #  Visualisation - Libvirt(QEMU/KVM) / Docker / LXD / WayDroid
      #
      ###################################################################################
      imports = [
      ];
      virtualisation.waydroid.enable = true;
    };
  den.aspects.vm.homeManager =
    { pkgs, ... }:
    {

      home.packages = with pkgs; [
        colima
        lima
      ];
    };
}
