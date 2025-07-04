{ flake, ... }:
{
  imports = [
    flake.inputs.mac-app-util.homeManagerModules.default
    ./hammerspoon
  ];

}
