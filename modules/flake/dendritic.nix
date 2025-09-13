{ inputs, ... }:
{

  imports = [
    inputs.flake-file.flakeModules.dendritic
  ];
  flake-file.inputs = {
    flake-file.url = "github:vic/flake-file";
  };
  flake-file.write-hooks = {
    enable = true;
  };
  flake-file.check-hooks = {
    enable = true;
  };
}
