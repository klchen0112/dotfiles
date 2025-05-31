# Configuration common to all macOS systems
{ flake, ... }:
let
  inherit (flake) config inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.common
    inputs.agenix.darwinModules.default
    ./homebrew
    ./areospace
  ];
}
