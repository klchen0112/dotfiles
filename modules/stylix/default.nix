{
  inputs,
  ...
}:
{
  imports = [
    ./base.nix
    inputs.stylix.nixosModules.stylix
  ];
}
