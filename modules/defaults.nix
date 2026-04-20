{
  lib,
  den,
  # deadnix: skip # enable <den/brackets> syntax for demo.
  __findFile,
  inputs,
  ...
}:
{
  den.default.nixos =
    { pkgs, lib, ... }:
    {
      system.stateVersion = "25.11";
      programs.dconf.enable = true;
      time.timeZone = "Asia/Shanghai";
      imports = [
        inputs.disko.nixosModules.disko
      ];
      boot.loader.systemd-boot.enable = true;
      users.mutableUsers = false;
      services.openssh = {
        enable = true;
        authorizedKeysInHomedir = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "prohibit-password";
          AllowUsers = [
            "klchen"
            "root"
          ];
        };
      };
      #  zramSwap.enable = true;
      home-manager.backupFileExtension = "hmbp";
      nixpkgs.overlays = [
        # Use nixpkgs from your environment, nixpkgs.config will apply.
        # Has small chance of kernel modules not being compatible with kernel version.
        inputs.nix-cachyos-kernel.overlays.default
      ];
      boot.kernelPackages = lib.mkDefault pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto-x86_64-v4;
    };
  den.default.wsl = {
    # system.stateVersion = "25.11";
    # time.timeZone = "Asia/Shanghai";
    enable = true;
    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;

    startMenuLaunchers = true;
    # home-manager.backupFileExtension = "hmbp";

  };

  den.default.homeManager = {
    home.stateVersion = "25.11";
  };
  den.default.darwin = {
    system.stateVersion = 6;
    home-manager.users.klchen.home.homeDirectory = "/Users/klchen";
  };
  # These are functions that produce configs
  den.default.includes = [
    # ${user}.provides.${host} and ${host}.provides.${user}
    <den/mutual-provider>

    # Automatically set hostname
    <den/hostname>

    # Automatically create the user on host.
    <den/define-user>
  ];
  # enable hm by default
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
}
