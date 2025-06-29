{
  flake,
  ...
}:
{
  imports = [
    ./common
    ./access-tokens.nix
    ./fonts
    ./stylix.nix
    ./hardware
    ./network
    flake.inputs.srvos.nixosModules.mixins-terminfo
    flake.inputs.srvos.nixosModules.mixins-nix-experimental
    flake.inputs.srvos.nixosModules.mixins-trusted-nix-caches
  ];
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };
}
