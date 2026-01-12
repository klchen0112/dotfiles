let
  machine = "r2070";
in
{
  inputs,
  ...
}:
{
  flake.meta.machines.${machine} = {

    hostName = "${machine}";
    platform = "x86_64-linux";
    sshKey = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsw5gk6koAb2D1SYnHt3jhYLNCWChR6eFKJ3vPO3tZY"
    ];
    base16Scheme = "selenized-light";
    users = [ "klchen" ];
  };
  flake.modules.nixos.${machine} =
    { config, ... }:
    {
      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      imports = (
        builtins.map (user: inputs.self.modules.nixos.${user}) config.flake.meta.machines.a99r50.users
      );

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
