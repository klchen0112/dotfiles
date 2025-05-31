# fish configuration
#
{
  lib,
  inputs,
  pkgs,
  isWork,
  config,
  ...
}:
{
  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };

}
