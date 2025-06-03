{
  flake,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    flake.inputs.agenix.packages.${pkgs.system}.default
  ];
  imports = [ flake.inputs.agenix.nixosModules.default ];
  age.secrets.access-tokens.file = flake.inputs.self + /secrets/access-tokens.age;
}
