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
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3hO4yhyrO8JHbP6yokAEbRDPb4FR/bhtoIb2rIBP5q root@i12r20"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHRBuSM5DLKYUtS1gmoZEA+y2xGrWWtxs3HEutD1LCwx root@init"
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9ZvdIrZP9su70iBKgCB0QOY0kL9Z9qu3B9Of05VS5a root@mbp-m1"
            ];
        };
        nix.settings.trusted-users = [ "remotebuild" ];

        nix.distributedBuilds = true;
        nix.settings.builders-use-substitutes = true;
      };
  };
}
