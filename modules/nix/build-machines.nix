{ den, ... }:
{
  den.aspects.nix-build-machines = {
    nixos =
      { lib, pkgs, ... }:
      {
        users.groups.remotebuild = { };
        users.users.remotebuild = {
          isSystemUser = true;
          group = "remotebuild";
          useDefaultShell = true;
          openssh.authorizedKeys.keys =
            [
              "ssh-ed25519 AAAAhosts/a99r50/hosts/a99r50/C3NzaC1lZDI1NTE5AAAAIO3hO4yhyrO8JHbP6yokAEbRDPb4FR/bhtoIb2rIBP5q root@i12r20"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHRBuSM5DLKYUtS1gmoZEA+y2xGrWWtxs3HEutD1LCwx root@init"
            ];
        };
        services.openssh.settings.AllowUsers = [
          "remotebuild"
        ];

        nix.settings.trusted-users = [ "remotebuild" ];

        nix.distributedBuilds = true;
        nix.settings.builders-use-substitutes = true;
        nix.buildMachines = [
          {
            hostName = "i12400.klchen.duckdns.org";
            sshKey = "/etc/ssh/ssh_host_ed25519_key";
            sshUser = "remotebuild";
            system = "x86_64-linux";
            supportedFeatures = [
              "big-parallel"
              "kvm"
            ];
          }
          {
            hostName = "a99r50.klchen.duckdns.org";
            sshUser = "remotebuild";
            system = "x86_64-linux";
            sshKey = "/etc/ssh/ssh_host_ed25519_key";
            supportedFeatures = [
              "big-parallel"
              "kvm"
            ];
          }

        ];
      };
  };
}
