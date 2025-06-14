{
  pkgs,
  config,
  flake,
  ...
}:
{
  imports = [
    ./common
    ./homebrew
    ./access-tokens.nix
    ./system
    flake.inputs.stylix.darwinModules.stylix
  ];
}
