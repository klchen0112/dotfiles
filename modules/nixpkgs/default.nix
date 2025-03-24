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
    ./base.nix
  ];
  nix.gc.dates = "weekly";

  nix.settings.trusted-users = [
    "root"
    "${username}"
    "@wheel"
  ];
  nix.extraOptions = ''
    !include ${config.age.secrets.access-tokens.path}
  '';
  # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
  # https://github.com/NixOS/nix/issues/9574
  nix.settings.nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
}
