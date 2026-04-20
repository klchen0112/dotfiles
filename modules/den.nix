{
  inputs,
  lib,
  den,
  ...
}:
let
  roleClass =
    { host, user }:
    { class, aspect-chain }:
    den._.forward {
      each = lib.intersectLists (host.roles or [ ]) (user.roles or [ ]);
      fromClass = lib.id;
      intoClass = _: "homeManager";
      intoPath = _: [ ];
      fromAspect = _: lib.head aspect-chain;
    };
in
{
  flake-file.inputs = {
    den.url = "github:vic/den";
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  imports = [
    (inputs.flake-file.flakeModules.dendritic or { })
    (inputs.den.flakeModules.dendritic or { })
  ];
  den.ctx.user.includes = [
    roleClass
    den.provides.mutual-provider

  ];
  _module.args.__findFile = den.lib.__findFile;
}
