{ config, pkgs, lib, inputs, username, ... }:

{
  networking = {
    hostName = "i12500"; # Define your hostname.
    networkmanager.enable = true;

  };


}
