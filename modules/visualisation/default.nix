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
        containerd = {
          enable = true;
        };
      };

    };
  flake.modules.nixos.waydroid =
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
  flake.modules.homeManager.vm =
    { pkgs, ... }:
    {

      home.packages = with pkgs; [
        colima
        lima
      ];
    };
}
