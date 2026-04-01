{
  lib,
  den,
  inputs,
  ...
}:
{
  den.default.nixos = {
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
        PermitRootLogin = "without-password";
      };
    };
    zramSwap.enable = true;
    home-manager.backupFileExtension = "hmbp";

  };
  den.default.wsl = {
    system.stateVersion = "25.11";
    services.openssh.enable = true;
    time.timeZone = "Asia/Shanghai";
    wsl = {
      enable = true;
      wslConf.automount.root = "/mnt";
      wslConf.interop.appendWindowsPath = false;
      wslConf.network.generateHosts = false;

      startMenuLaunchers = true;
    };
    # home-manager.backupFileExtension = "hmbp";

  };

  den.default.homeManager = {
    home.stateVersion = "25.11";
  };

  # enable hm by default
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  # host<->user provides
  den.ctx.user.includes = [ den._.mutual-provider ];
}
