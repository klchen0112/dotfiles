{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  nixpkgs,
  ...
}:
{
  imports = [
    ./base.nix
  ];
  nix.gc.dates = "weekly";
  # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
  # nix.registry.nixpkgs.flake = nixpkgs;
  nix.channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.
  nix.settings.trusted-users = [
    "root"
    "${username}"
    "@wheel"
  ];
  nix.extraOptions = ''
    !include ${config.age.secretsDir}access-tokens
  '';
}
