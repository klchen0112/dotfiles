{
  flake,
  pkgs,
  config,
  ...
}:
{
  environment.systemPackages = [
    flake.inputs.agenix.packages.${pkgs.system}.default
  ];
  imports = [ flake.inputs.agenix.nixosModules.default ];
  age.secrets.access-tokens.file = flake.inputs.self + /secrets/access-tokens.age;
  nix.extraOptions = ''
    !include ${config.age.secrets.access-tokens.path}
  '';
}
