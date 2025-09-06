{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (builtins)
    pathExists
    readDir
    readFileType
    elemAt
    isList
    ;
  inherit (lib)
    mkOption
    types
    optionals
    literalExpression
    mapAttrs
    concatMapAttrs
    genAttrs
    id
    ;
  inherit (lib.strings) hasSuffix removeSuffix;
  users = config.users;
  machines = config.machines;
in
{
  config.flake = {
    # homeModules = injectEarly cfg.home.earlyModuleArgs (readModules {
    #   dir = cfg.home.modulesDirectory;
    # });
    # nixosModules = injectEarly cfg.nixos.earlyModuleArgs (readModules {
    #   dir = cfg.nixos.modulesDirectory;
    # });
    # darwinModules = injectEarly cfg.darwin.earlyModuleArgs (readModules {
    #   dir = cfg.darwin.modulesDirectory;
    # });

  };
}
