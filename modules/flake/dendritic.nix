{ inputs, ... }:
{

  imports = [
    inputs.flake-file.flakeModules.dendritic
  ];
  flake-file.inputs = {
    flake-file.url = "github:vic/flake-file";
    allfollow.url = "github:spikespaz/allfollow";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };
  flake-file.prune-lock = {
    enable = true;
  };
  systems = import inputs.systems;
}
