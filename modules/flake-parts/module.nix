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
  readModules =
    {
      dir,
      entryPoint ? "default.nix",
    }:
    if pathExists "${dir}.nix" && readFileType "${dir}.nix" == "regular" then
      { default = dir; }
    else if pathExists dir && readFileType dir == "directory" then
      concatMapAttrs (
        entry: type:
        let
          dirDefault = "${dir}/${entry}/${entryPoint}";
        in
        if type == "regular" && hasSuffix ".nix" entry then
          { ${removeSuffix ".nix" entry} = "${dir}/${entry}"; }
        else if pathExists dirDefault && readFileType dirDefault == "regular" then
          { ${entry} = dirDefault; }
        else
          { }
      ) (readDir dir)
    else
      { };
in
{
  config.flake = {
    homeModules = (
      readModules {
        dir = "./modules/home";
      }
    );
    nixosModules = (
      readModules {
        dir = "./modules/nixos";
      }
    );
    darwinModules = (
      readModules {
        dir = "./modules/darwin";
      }
    );
    # overlays
    # darwin
    # linux
    # android

  };
}
