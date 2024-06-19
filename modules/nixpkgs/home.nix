{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  ...
}: {
  nix.gc = {
    automatic = true;
    frequency = "weekly";
  };
}
