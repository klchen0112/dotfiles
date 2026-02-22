let
  machine = "sanjiao";
in
{ inputs, config, ... }:
{

  flake.meta.machines.${machine} = {

    hostName = "sanjiao";
    platform = "x86_64-linux";
    sshKey = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID8T9wyRN9CA/wWN70aHaRoAi1BRFeWkIjfL6+sycRaI" ];
    base16Scheme = "selenized-light";
    users = [ "klchen" ];
  };
  flake.modules.nixos.${machine} = {
    imports = [
      inputs.self.modules.nixos.font
      # inputs.self.modules.nixos.access-tokens
      inputs.self.modules.nixos.vm
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      # offload
      inputs.nixos-hardware.nixosModules.common-pc-ssd
    ]
    ++ (builtins.map (
      user: inputs.self.modules.nixos.${user}
    ) config.flake.meta.machines.${machine}.users);

    home-manager.users.klchen.imports = with config.flake.modules.homeManager; [
      #  access-tokens
    ];
    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

  };
}
