# This is your nixos configuration.
# For home configuration, see /modules/home/*
{ flake, ... }:
{
  imports = [
    ./common
    ./linux/access-tokens.nix
  ];
  services.openssh.enable = true;
}
