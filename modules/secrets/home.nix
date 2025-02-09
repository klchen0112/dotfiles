{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.agenix.homeManagerModules.default
  ];
  home.packages = [
    inputs.agenix.packages.${pkgs.system}.default
  ];
  age = {
    secretsDir = "${config.home.homeDirectory}/.config/agenix/agenix";
    secretsMountPoint = "${config.home.homeDirectory}/.config/agenix/agenix.d";
    secrets.access-tokens.file = "${inputs.agenix-secrets}/access-tokens.age";
  };
}
