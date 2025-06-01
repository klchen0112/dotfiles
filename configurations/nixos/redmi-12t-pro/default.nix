{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.default
    ./hardware-configuration.nix
  ];

  # Defined by /modules/home/me.nix
  # And used all around in /modules/home/*
  me = flake.users.klchen;
}
