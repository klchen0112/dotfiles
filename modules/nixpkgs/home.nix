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
  nix.gc = {
    automatic = true;
    frequency = "weekly";
  };
  
  nix.extraOptions = ''
    !include ${config.age.secretsDir}/access-tokens
  '';
}
