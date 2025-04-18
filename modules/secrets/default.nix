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
  imports = [ inputs.agenix.nixosModules.default ];
  age.secrets.access-tokens.file = "${inputs.agenix-secrets}/access-tokens.age";
}
