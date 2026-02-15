let
  machine = "r2070";
in
{
  inputs,
  config,
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
    { ... }:
    {

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
        inputs.nixos-hardware.nixosModules.common-cpu-amd-raphael-igpu
        # offload
        inputs.nixos-hardware.nixosModules.common-gpu-nvidia
        inputs.nixos-hardware.nixosModules.common-pc-ssd
        inputs.nixos-hardware.nixosModules.common-hidpi
      ]
      ++ (with inputs.self.modules.nixos; [
        niri
        noctalia-shell
      ])
      ++ (builtins.map (user: inputs.self.modules.nixos.${user}) config.flake.meta.machines.r2070.users);

      home-manager.users.klchen.imports = with config.flake.modules.homeManager; [
        niri
        noctalia-shell
        ghostty
        aria2
        bash
        syncthing
      ];
    };
}
