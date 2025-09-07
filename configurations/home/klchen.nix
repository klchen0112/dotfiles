{
  flake,
  lib,
  pkgs,
  desktop,
  ...
}:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.default
    self.homeModules.nushell
    self.homeModules.starship
    self.homeModules.access-tokens
  ]
  ++ (lib.optionals pkgs.stdenv.isLinux [
    (self + /modules/home/bash)
  ])
  ++ (lib.optionals pkgs.stdenv.isDarwin [
    (self + /modules/home/zsh)
  ])
  ++ (lib.optionals desktop [
    (self + /modules/home/desktop.nix)
  ])
  ++ (lib.optionals (desktop && pkgs.stdenv.isLinux) [
    (self + /modules/home/desktop-linux.nix)
  ])
  ++ (lib.optionals (desktop && pkgs.stdenv.isDarwin) [
    (self + /modules/home/desktop-darwin.nix)
  ]);

  # Defined by /modules/home/me.nix
  # And used all around in /modules/home/*
  me = flake.config.users.klchen;
  home.stateVersion = "25.05";
}
