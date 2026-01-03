{ inputs, config, ... }:
{

  flake.meta.machines.sanjiao = {

    hostName = "sanjiao";
    platform = "x86_64-linux";
    sshKey = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID8T9wyRN9CA/wWN70aHaRoAi1BRFeWkIjfL6+sycRaI" ];
    base16Scheme = "selenized-light";
    users = [ "klchen" ];
  };
  flake.modules.nixos.sanjiao = {
    imports = [
      inputs.self.modules.nixos.klchen
      inputs.self.modules.nixos.font
      inputs.self.modules.nixos.access-tokens
      inputs.self.modules.nixos.vm
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      # offload
      inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];
    home-manager.users.klchen.imports = with config.flake.modules.homeManager; [
      access-tokens
    ];
    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    system.stateVersion = "25.05";
  };
}
