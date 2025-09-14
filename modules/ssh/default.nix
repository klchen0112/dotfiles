{
  flake.modules.homeManager.ssh =
    {
      config,
      ...
    }:
    {
      programs.ssh = {
        enable = true;
        serverAliveInterval = 30;
        serverAliveCountMax = 6;
        compression = true;
        controlMaster = "auto";
        controlPath = "${config.home.homeDirectory}/.ssh/cm/%r@%h";
        controlPersist = "10m";
        matchBlocks = {
          xiaomi = {
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
          a3400g = {
            hostname = "192.168.0.197";
            port = 22;
            user = "klchen";
          };
          sanjiao = {
            hostname = "192.168.0.198";
            port = 22;
            user = "klchen";
          };
          woniu = {
            hostname = "192.168.0.199";
            port = 22;
            user = "klchen";
          };
          unraid = {
            hostname = "192.168.0.200";
            port = 22;
            user = "root";
          };
          duxiaoman = {
            hostname = "relay00.duxiaoman-int.com";
            port = 22;
            user = "chenkailong_dxm";
          };
          xd = {
            hostname = "relay00.dxmxd02-int.com";
            port = 22;
            user = "chenkailong_dxm";
          };
          kj = {
            hostname = "relay00.dxmkj01-int.com";
            port = 22;
            user = "chenkailong_dxm";
          };
          i12r20 = {
            # hostkeyAlgorithms = "+ssh-rsa";
            # pubkeyAcceptedAlgorithms = "+ssh-rsa";
            hostname = "192.168.88.191";
            port = 22;
            user = "klchen";
          };
          a99r50 = {
            # hostkeyAlgorithms = "+ssh-rsa";
            # pubkeyAcceptedAlgorithms = "+ssh-rsa";
            hostname = "a99r50.klchen.dns.army";
            port = 22;
            user = "klchen";
          };
        };
      };
    };
}
