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
  users.users.${username} =
    {
      home = if pkgs.stdenv.isLinux then "/home/${username}" else "/Users/${username}";
      extraGroups = [
        "wheel"
        "networkmanager"
        "seat"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGszCNQqxT1/s6sYjj1aewvCjaa3D7UwoOM7UD5K+ha klchen0112@gmail.com"
      ];
    }
    ++ (
      if pkgs.stdenv.isLinux then
        {
          isNormalUser = true;
        }
      else
        {

        }
    );
}
