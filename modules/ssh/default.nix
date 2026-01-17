{
  flake.modules.nixos.ssh = {
    services.openssh = {
      enable = true;
      authorizedKeysInHomedir = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "without-password";
      };
    };
  };
  flake.modules.homeManager.ssh =
    {
      config,
      ...
    }:
    {
      programs.ssh = {
        enable = true;

        matchBlocks = {
          "*" = {
            serverAliveInterval = 30;
            serverAliveCountMax = 6;
            compression = true;
            controlMaster = "auto";
            controlPath = "${config.home.homeDirectory}/.ssh/cm/%r@%h";
            controlPersist = "10m";
          };
          xiaomi-ax6000 = {
            # hostkeyAlgorithms = "+ssh-rsa";
            # pubkeyAcceptedAlgorithms = "+ssh-rsa";
            hostname = "192.168.0.10";
            port = 22;
            user = "root";
          };
          # ax5 = {
          #   # hostkeyAlgorithms = "+ssh-rsa";
          #   # pubkeyAcceptedAlgorithms = "+ssh-rsa";
          #   hostname = "192.168.0.10";
          #   port = 22;
          #   user = "root";
          # };
          "github.com" = {
            hostname = "ssh.github.com";
            port = 443;
            user = "git";
          };
          a3400g = {
            hostname = "a3400g.klchen.duckdns.org";
            port = 22;
            user = "klchen";
          };
          sanjiao = {
            hostname = "sanjiao.klchen.duckdns.org";
            port = 22;
            user = "klchen";
          };
          woniu = {
            hostname = "woniu.klchen.duckdns.org";
            port = 22;
            user = "klchen";
          };
          unraid = {
            hostname = "192.168.0.200";
            port = 22;
            user = "root";
          };
          i12r20 = {
            # hostkeyAlgorithms = "+ssh-rsa";
            # pubkeyAcceptedAlgorithms = "+ssh-rsa";
            hostname = "i12r20.klchen.duckdns.org";
            port = 22;
            user = "klchen";
          };
          a99r50 = {
            # hostkeyAlgorithms = "+ssh-rsa";
            # pubkeyAcceptedAlgorithms = "+ssh-rsa";
            hostname = "a99r50.klchen.duckdns.org";
            port = 22;
            user = "klchen";
          };
        };
      };
    };
}
