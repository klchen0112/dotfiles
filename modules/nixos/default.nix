{
  flake,
  lib,
  ...
}:
{
  imports = [
    ./common
    ./fonts
    ./stylix
    ./hardware
    ./network
    flake.inputs.srvos.nixosModules.mixins-terminfo
    flake.inputs.srvos.nixosModules.mixins-nix-experimental
    flake.inputs.srvos.nixosModules.mixins-trusted-nix-caches
  ];
  services.openssh = {
    enable = lib.mkForce true;
    settings.PermitRootLogin = "no";
  };
  zramSwap = {
    enable = true;
  };
  boot.initrd.systemd.enable = true;
  networking.useDHCP = lib.mkDefault true;
}
