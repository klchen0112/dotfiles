{ inputs, ... }:
{
  flake.modules.nixos.nixos = {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    programs.dconf.enable = true;
    imports = with inputs.self.modules.nixos; [
      network
    ];
    time.timeZone = "Asia/Shanghai";
  };
  flake.modules.nixos.wsl = {
    services.openssh.enable = true;
    programs.dconf.enable = true;
    imports = with inputs; [
      nixos-wsl.nixosModules.wsl
    ];
    time.timeZone = "Asia/Shanghai";

    wsl = {
      enable = true;
      wslConf.automount.root = "/mnt";
      wslConf.interop.appendWindowsPath = false;
      wslConf.network.generateHosts = false;

      startMenuLaunchers = true;
    };
  };
}
