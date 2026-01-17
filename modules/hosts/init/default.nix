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

      # networking
      networking.useNetworkd = lib.mkForce true;
      networking.useDHCP = lib.mkForce false;

      environment.systemPackages = with pkgs; [
        just
        git
        neovim
        pciutils
      ];

      # Don't allow mutation of users outside of the config.
      users.mutableUsers = false;
      zramSwap.enable = true;
    };
}
