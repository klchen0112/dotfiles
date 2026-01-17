let
  machine = "wsl-nixos";
in
{
  inputs,
  config,
  lib,
  ...
}:
{
  flake.meta.machines.${machine} = {
    hostName = "${machine}";
    platform = "x86_64-linux";
    base16Scheme = "selenized-light";
    sshKey = [

    ];
    users = [
      "klchen"
    ];
    desktop = false;
  };
  flake.modules.nixos.wsl-nixos =
    {
      lib,
      pkgs,
      ...
    }:
    {
      home-manager.users.klchen.imports = with config.flake.modules.homeManager; [
        bash
        emacs-twist
      ];
      home-manager.backupFileExtension = "hmbp";

      imports = (
        builtins.map (user: inputs.self.modules.nixos.${user}) config.flake.meta.machines.${machine}.users
      );

      wsl.defaultUser = lib.lists.head config.flake.meta.machines.wsl-nixos.users;

      # Don't allow mutation of users outside of the config.
      users.mutableUsers = false;
      zramSwap.enable = true;
    };
}
