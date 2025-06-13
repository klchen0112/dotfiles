# Top-level configuration for everything in this repo.
#
# Values are set in 'config.nix' in repo root.
{ lib, ... }:
let
  userSubmodule = lib.types.submodule {
    options = {
      username = lib.mkOption {
        type = lib.types.str;
      };
      fullname = lib.mkOption {
        type = lib.types.str;
      };
      email = lib.mkOption {
        type = lib.types.str;
      };
      initialHashedPassword = lib.mkOption {
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
      root = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
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
          name of users
        '';
      };
      desktop = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
in
{
  imports = [
    ../../config.nix
  ];
  options = {
    users = lib.mkOption {
      type = lib.types.attrsOf userSubmodule;
    };
    machines = lib.mkOption {
      type = lib.types.attrsOf machineSubmodule;
    };
  };
}
