{ den, ... }:
let
  machines = {
    i12400 = {
      hostName = "i12400";
      maxJobs = 16;
      speedFactor = 1;
      supportedFeatures = [
        "kvm"
        "big-parallel"
      ];
    };
    a2700 = {
      hostName = "a2700";
      maxJobs = 16;
      speedFactor = 1;
      supportedFeatures = [
        "kvm"
        "big-parallel"
      ];
    };
  };
in
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
        };
        nix.settings.trusted-users = [ "remotebuild" ];

        nix.distributedBuilds = true;
        nix.settings.builders-use-substitutes = true;
        nix.buildMachines = [
          {
            hostName = "i12400";
            sshUser = "remotebuild";
            system = pkgs.stdenv.hostPlatform.system;
            supportedFeatures = [
              "big-parallel"
              "kvm"
            ];
          }
          {
            hostName = "a2700";
            sshUser = "remotebuild";
            system = pkgs.stdenv.hostPlatform.system;
            supportedFeatures = [
              "big-parallel"
              "kvm"
            ];
          }
        ];
      };
  };
}
