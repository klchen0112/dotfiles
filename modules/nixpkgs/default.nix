{ inputs
, outputs
, config
, pkgs
, username
, system
, ...
}: {
  imports = [
    ./base.nix
  ];
  nix.gc.dates = "weekly";
}
