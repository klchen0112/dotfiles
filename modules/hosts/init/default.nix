{ inputs, ... }:
{
  flake.meta.machines.init = {
    hostName = "init";
    platform = "x86_64-linux";
    base16Scheme = "selenized-light";
    sshKey = [

    ];
    users = [
      "klchen"
    ];
    desktop = false;
  };
  flake.modules.nixos.init =
    {
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.disko.nixosModules.disko
      ];

      nixpkgs.hostPlatform = "x86_64-linux";
      # Bootloader.
      boot.loader.systemd-boot.enable = true;

      environment.systemPackages = with pkgs; [
        just
        git
        pciutils
      ];

      # Don't allow mutation of users outside of the config.
      users.mutableUsers = false;
      zramSwap.enable = true;
    };
}
