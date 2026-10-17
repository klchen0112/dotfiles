{
  den.aspects.ssh.homeManager =
    {
      config,
      ...
    }:
    {
      programs.ssh = {
        enable = true;

        # Home Manager used to inject a "Host *" block with these defaults
        # (programs.ssh.enableDefaultConfig). That behaviour is being removed,
        # so keep the values we depend on explicitly.
        enableDefaultConfig = false;

        # Upstream OpenSSH directive names, in a dag keyed by host pattern.
        # Bare names are prefixed with "Host ", so "*" becomes "Host *".
        settings = {
          "*" = {
            ForwardAgent = false;
            AddKeysToAgent = "no";
            HashKnownHosts = false;
            UserKnownHostsFile = "~/.ssh/known_hosts";
            ServerAliveInterval = 30;
            ServerAliveCountMax = 6;
            Compression = true;
            ControlMaster = "auto";
            ControlPath = "${config.home.homeDirectory}/.ssh/cm/%r@%h";
            ControlPersist = "10m";
          };

          xiaomi-ax6000 = {
            # HostKeyAlgorithms = "+ssh-rsa";
            # PubkeyAcceptedAlgorithms = "+ssh-rsa";
            HostName = "192.168.0.10";
            Port = 22;
            User = "root";
          };

          # ax5 = {
          #   # HostKeyAlgorithms = "+ssh-rsa";
          #   # PubkeyAcceptedAlgorithms = "+ssh-rsa";
          #   HostName = "192.168.0.10";
          #   Port = 22;
          #   User = "root";
          # };

          "github.com" = {
            HostName = "ssh.github.com";
            Port = 443;
            User = "git";
          };

          a2700 = {
            HostName = "a2700.klchen.duckdns.org";
            Port = 22;
            User = "klchen";
          };

          sanjiao = {
            HostName = "sanjiao.klchen.duckdns.org";
            Port = 22;
            User = "klchen";
          };

          woniu = {
            HostName = "woniu.klchen.duckdns.org";
            Port = 22;
            User = "klchen";
          };

          unraid = {
            HostName = "192.168.0.200";
            Port = 22;
            User = "root";
          };

          i12400 = {
            # HostKeyAlgorithms = "+ssh-rsa";
            # PubkeyAcceptedAlgorithms = "+ssh-rsa";
            HostName = "i12400.klchen.duckdns.org";
            Port = 22;
            User = "klchen";
          };

          a99r50 = {
            # HostKeyAlgorithms = "+ssh-rsa";
            # PubkeyAcceptedAlgorithms = "+ssh-rsa";
            HostName = "a99r50.klchen.duckdns.org";
            Port = 22;
            User = "klchen";
          };
        };
      };
    };
}
