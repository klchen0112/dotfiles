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
  ];

  # Defined by /modules/home/me.nix
  # And used all around in /modules/home/*
  me = flake.config.users.chenkailong_dxm;
  home.stateVersion = "25.05";
}
