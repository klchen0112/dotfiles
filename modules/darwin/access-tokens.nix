{ flake, config, ... }:

let
  inherit (flake.inputs) self;
  inherit (flake) inputs;
in
{
  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.system}.default
  ];
  imports = [ inputs.agenix.darwinModules.default ];
  age.secrets.access-tokens.file = self + /secrets/access-tokens.age;
}
