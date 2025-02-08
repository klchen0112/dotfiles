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
  age.secrets.access-tokens.file = "${inputs.agenix-secrets}/access-tokens.age";
}
