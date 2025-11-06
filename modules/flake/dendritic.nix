{ inputs, ... }:
{

  imports = [
    inputs.flake-file.flakeModules.dendritic
    inputs.flake-parts.flakeModules.modules
  ];
  flake-file.inputs = {
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  systems = import inputs.systems;
}
