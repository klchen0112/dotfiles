{
  inputs,
  lib,
  den,
  ...
}:
let
  rolesOption = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    apply = lib.unique;
    description = "Role classes enabled for this host or user.";
  };
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
  hmPlatforms =
    { class, aspect-chain }:
    den.provides.forward {
      each = [
        "Linux"
        "Darwin"
      ];
      fromClass = platform: "hm${platform}";
      intoClass = _: "homeManager";
      intoPath = _: [ ];
      fromAspect = _: lib.head aspect-chain;
      guard = { pkgs, ... }: platform: lib.mkIf pkgs.stdenv.hostPlatform."is${platform}";
      adaptArgs =
        { config, ... }:
        {
          osConfig = config;
        };
    };
in
{
  flake-file.inputs = {
    den.url = "github:vic/den";
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
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
  den.schema.host = { config, ... }: {
    options.roles = rolesOption;
    # Include every user's roles while preserving explicit host-only roles.
    config.roles = lib.concatMap (user: user.roles) (lib.attrValues config.users);
  };
  den.schema.user.imports = [
    { options.roles = rolesOption; }
  ];
  den.schema.user.includes = [
    roleClass
    hmPlatforms
    den.provides.mutual-provider
  ];
  _module.args.__findFile = den.lib.__findFile;
}
