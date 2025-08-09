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
  boot = {
    tmp.useTmpfs = true;
    tmp.tmpfsSize = "10G";
  };
  zramSwap = {
    enable = true;
  };
}
