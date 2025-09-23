{ inputs, ... }:
{
  flake.modules.darwin.nix = {
    nix.channel.enable = false;
  };
  flake.modules.nixos.nix = {
    nix.channel.enable = false;

  };

}
