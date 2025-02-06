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
  nix = {
    # package = pkgs.nixVersions.latest;
    # channel.enable = false;

    # optimise = {
    #   automatic = true;

    # options = "--delete-older-than 7d";
    # };
  };
}
