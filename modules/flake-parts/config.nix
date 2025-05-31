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
      # fullname = lib.mkOption {
      #   type = lib.types.str;
      # };
      email = lib.mkOption {
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
    users = {
      klchen = lib.mkOption {
        type = userSubmodule;
      };
      chenkailong_dxm = lib.mkOption {
        type = userSubmodule;
      };
    };
    machines = {
      a3400g = lib.mkOption {
        type = machineSubmodule;
      };
      sanjiao = lib.mkOption {
        type = machineSubmodule;
      };
      i12700 = lib.mkOption {
        type = machineSubmodule;
      };
      mbp-dxm = lib.mkOption {
        type = machineSubmodule;
      };
      mbp-m1 = lib.mkOption {
        type = machineSubmodule;
      };
    };
  };
}
