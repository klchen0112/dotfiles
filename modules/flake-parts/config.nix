# Top-level configuration for everything in this repo.
#
# Values are set in 'config.nix' in repo root.
{ lib, ... }:
let
  userSubmodule = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
      };
      # fullname = lib.mkOption {
      #   type = lib.types.str;
      # };
      email = lib.mkOption {
        type = lib.types.str;
      };
      base16Scheme = lib.mkOption {
        type = lib.types.str;
      };
      sshKey = lib.mkOption {

        type = lib.types.listOf lib.types.singleLineStr;
        description = ''
          SSH public key
        '';
      };
    };
  };
  machineSubmodule = lib.types.submodule {
    options = {
      hostname = lib.mkOption {
        type = lib.types.str;
      };
      # fullname = lib.mkOption {
      #   type = lib.types.str;
      # };
      platform = lib.mkOption {
        type = lib.types.str;
      };
      sshKey = lib.mkOption {
        type = lib.types.listOf lib.types.singleLineStr;
        description = ''
          SSH public key
        '';
      };
    };
  };
in
{
  imports = [
    ../../config.nix
  ];
  options = {
    me = lib.mkOption {
      type = userSubmodule;
    };
    machine = lib.mkOption {
      type = machineSubmodule;
    };

    users = lib.mkOption {
      type = lib.types.attrsOf userSubmodule;
    };
    machines = lib.mkOption {
      type = lib.types.attrsOf machineSubmodule;
    };
  };
}
