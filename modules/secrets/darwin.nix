{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.system}.default
  ];
  imports = [ inputs.agenix.darwinModules.default ];
  age.secrets.access-tokens.file = "${inputs.agenix-secrets}/access-tokens.age";
}
