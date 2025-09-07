{
  pkgs,
  config,
  flake,
  lib,
  ...
}:
let
  machineSubmodule = lib.types.submodule {
    options = {
      hostName = lib.mkOption {
        type = lib.types.str;
      };
      platform = lib.mkOption {
        type = lib.types.str;
      };
      base16Scheme = lib.mkOption {
        type = lib.types.str;
      };
      sshKey = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          SSH public key
        '';
      };
      users = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          list of user
        '';
      };
      desktop = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
  inherit (flake.inputs) self;
  mapListToAttrs =
    m: f:
    lib.listToAttrs (
      map (name: {
        inherit name;
        value = f name;
      }) m
    );
in
{
  options = {
    machine = lib.mkOption {
      type = machineSubmodule;
    };
  };
  imports = [
    ./common
    ./homebrew
    ./system
    ./stylix
  ];
  programs.zsh.enable = true;
}
