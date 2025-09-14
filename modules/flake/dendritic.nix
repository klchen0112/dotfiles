{ inputs, ... }:
{

  imports = [
    inputs.flake-file.flakeModules.dendritic
  ];
  flake-file.inputs = {
    flake-file.url = "github:vic/flake-file";
    allfollow.url = "github:spikespaz/allfollow";
  };
  flake-file.prune-lock = {
    enable = true;
  };
}
