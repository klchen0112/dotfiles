{
  inputs,
  ...
}:
{
  flake.meta.machines.a3400g = {

    hostName = "a3400g";
    platform = "x86_64-linux";
    sshKey = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsw5gk6koAb2D1SYnHt3jhYLNCWChR6eFKJ3vPO3tZY"
    ];
    base16Scheme = "selenized-light";
    users = [ "klchen" ];
  };
  flake.modules.nixos.a3400g =
    { config, ... }:
    {
      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      imports = [
        inputs.self.modules.nixos.klchen
      ];
      home-manager.users.klchen.imports = with config.flake.modules.homeManager; [
        niri
        ghostty
        aria2
        kitty
        bash
        syncthing
        emacs
      ];
    };
}
