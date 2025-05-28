{
  inputs,
  ...
}:
{
  imports = [
    ./base.nix
    inputs.stylix.darwinModules.stylix
  ];

}
