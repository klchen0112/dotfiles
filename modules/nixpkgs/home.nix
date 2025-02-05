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
}
