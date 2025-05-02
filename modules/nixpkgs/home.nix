{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  ...
}:
{
  imports = [
    ./nix.nix
  ];

  nix.extraOptions = ''
    !include ${config.age.secretsDir}/access-tokens
  '';
}
