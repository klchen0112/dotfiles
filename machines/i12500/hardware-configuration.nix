# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/24afcd71-ee1f-42e9-b28b-8bb5fe71026f";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/EFAC-2435";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/7c32372a-415e-4e8f-8478-b273b6544e03"; }];


  # Enable networking
  networking = {
    hostName = "i12500";
    # wireless.enable = true;
    wireless.userControlled.enable = true;
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };

  services.blueman.enable = true;

  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;


}
