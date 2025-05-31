{ flake
, config
, pkgs
, ...
}:

let
  inherit (flake.inputs) self;
  inherit (flake) inputs;
in
{
  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.system}.default
  ];
  imports = [ inputs.agenix.nixosModules.default ];
  age.secrets.access-tokens.file = self + /secrets/access-tokens.age;
}
