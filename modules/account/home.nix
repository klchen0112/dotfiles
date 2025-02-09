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

  home = {
    username = "${username}";
    homeDirectory = lib.mkDefault (
      if pkgs.stdenv.isLinux then "/home/${username}" else "/Users/${username}"
    );
    stateVersion = "25.05";
  };
}
