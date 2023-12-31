{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  ...
}: {
  imports = [
    ./base.nix
    ./nix.nix
  ];
  nix.gc.dates = "weekly";
  nix.registry.nixpkgs.flake = pkgs;
}
