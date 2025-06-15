{
  pkgs,
  config,
  flake,
  ...
}:
{
  imports = [
    flake.inputs.stylix.nixosModules.stylix
    ./common/stylix.nix
  ];
}
