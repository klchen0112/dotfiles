{ inputs, ... }:
{
  flake.modules.nixos.nixos = {
    services.openssh.enable = true;
  };
}
