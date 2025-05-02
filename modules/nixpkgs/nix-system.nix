{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  lib,
  ...
}:
{
  nix.channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.
  nix.extraOptions = ''
    !include ${config.age.secrets.access-tokens.path}
  '';
  # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
  # https://github.com/NixOS/nix/issues/9574
  nix.settings.nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
}
