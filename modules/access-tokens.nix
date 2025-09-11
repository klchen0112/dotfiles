{
  flake,
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    flake.inputs.agenix.packages.${pkgs.system}.default
  ];
  imports = [ flake.inputs.agenix.darwinModules.default ];
  age.secrets.access-tokens.file = flake.inputs.self + /secrets/access-tokens.age;
  nix.extraOptions = ''
    !include ${config.age.secrets.access-tokens.path}
  '';
}
