# Configuration common to all macOS systems
{ flake, ... }:
let
  inherit (flake) config inputs;
  inherit (inputs) self;
in
{
  imports = [
    ./common
    self.nixosModules.common
    ./homebrew
    ./areospace
    ./access-tokens.nix
    ./stylix.nix
  ];
}
