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
    ./stylix
  ];
}
