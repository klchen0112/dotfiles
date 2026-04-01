{ ... }:
{

  den.aspects.nix = {

    darwin = {
      nix.channel.enable = false;
    };
    nixos = {
      nix.channel.enable = false;

    };
  };
}
