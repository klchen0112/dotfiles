{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  nixpkgs,
  lib,
  ...
}:
{
  imports = [
    ./nix.nix
    ./nix-system.nix
    ./nixpkgs.nix
  ];
}
