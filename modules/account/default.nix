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

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGszCNQqxT1/s6sYjj1aewvCjaa3D7UwoOM7UD5K+ha"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyFiios12VBgf9kF4iuOU1VYQhwKz1wpUyADZAnyVGU"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII/c10VIo81cztYJza3e+l1JlwsTJQk1lhBOypGhYn3T"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKx1SNaQZ6v1onDSGz1wNX1W3zIf2KkTERjKGC+k157D"

      ];
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      isNormalUser = true;

      extraGroups = [
        "wheel"
        "networkmanager"
        "seat"
      ];
    };
}
