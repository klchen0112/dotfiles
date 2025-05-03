{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  isWork ? true,
  ...
}:
{
  imports = [ ./base.nix ];
  services.openssh.settings.PasswordAuthentication = false;
}
