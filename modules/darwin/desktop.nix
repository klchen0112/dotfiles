{ flake, ... }:
{
  imports = [
    flake.inputs.srvos.darwinModules.desktop
    flake.inputs.srvos.darwinModules.mixins-terminfo
    flake.inputs.srvos.darwinModules.mixins-nix-experimental
    flake.inputs.srvos.darwinModules.mixins-trusted-nix-caches
    flake.inputs.mac-app-util.darwinModules.default
  ];
}
