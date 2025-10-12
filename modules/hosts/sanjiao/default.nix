{

  flake.meta.machines.sanjiao = {

    hostName = "sanjiao";
    platform = "x86_64-linux";
    sshKey = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID8T9wyRN9CA/wWN70aHaRoAi1BRFeWkIjfL6+sycRaI" ];
    base16Scheme = "selenized-light";
    users = [ "klchen" ];
  };
  flake.modules.nixos.sanjiao = {

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    system.stateVersion = "25.05";
  };
}
