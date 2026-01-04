{ inputs, config,lib,... }:
{
  flake.meta.machines.wsl = {
    hostName = "wsl";
    platform = "x86_64-linux";
    base16Scheme = "selenized-light";
    sshKey = [

    ];
    users = [
      "klchen"
    ];
    desktop = false;
  };
  flake.modules.nixos.wsl =
    {
      lib,
      pkgs,
      ...
    }:
    {
      home-manager.users.klchen.imports = with config.flake.modules.homeManager; [
        bash
        emacs-twist
        access-tokens
        vm
      ];
      home-manager.backupFileExtension = "hmbp";

      imports = [
        inputs.self.modules.nixos.klchen
        inputs.self.modules.nixos.access-tokens
      ];
      wsl.defaultUser = lib.lists.head config.flake.meta.wsl.users;

      # Don't allow mutation of users outside of the config.
      users.mutableUsers = false;
      zramSwap.enable = true;
    };
}
