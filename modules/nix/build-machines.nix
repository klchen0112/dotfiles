{ den, ... }:
let
  machines = {
    i12400 = {
      hostName = "i12400";
      maxJobs = 16;
      speedFactor = 1;
      supportedFeatures = [ "kvm" "big-parallel" ];
    };
    a2700 = {
      hostName = "a2700";
      maxJobs = 16;
      speedFactor = 1;
      supportedFeatures = [ "kvm" "big-parallel" ];
    };
  };
in
{
  den.aspects.nix-build-machines = {
    nixos =
      { lib, ... }:
      {
        nix.settings.build-machines = lib.mapAttrsToList
          (name: cfg: {
            inherit (cfg) hostName maxJobs speedFactor supportedFeatures;
            user = "root";
            system = "x86_64-linux";
          })
          (lib.filterAttrs (name: _: lib.any (h: h == name) (den.hosts.x86_64-linux or { })) machines);
      };
  };
}
