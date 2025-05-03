{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  lib,
  nixpkgs,
  ...
}:
{
  imports = [
    ./nix.nix
    ./nix-system.nix
    ./nixpkgs.nix
  ];

  programs.nix-index.enable = true;

}
