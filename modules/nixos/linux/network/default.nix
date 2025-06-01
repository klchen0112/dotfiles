{ inputs
, outputs
, config
, pkgs
, username
, system
, nixpkgs
, ...
}:
{
  networking.networkmanager.enable = true;
}
