{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.default
    self.homeModules.nushell
    self.homeModules.starship
    self.homeModules.sync
  ];

  # Defined by /modules/home/me.nix
  # And used all around in /modules/home/*
  me = flake.config.users.klchen;
  home.stateVersion = "25.05";
}
