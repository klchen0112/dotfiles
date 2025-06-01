# This is your nixos configuration.
# For home configuration, see /modules/home/*
{ flake, ... }:
{
  imports = [
    ./common
  ];
  services.openssh.enable = true;
}
