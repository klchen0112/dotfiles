# Top-level configuration for everything in this repo.
#
# Values are set in 'config.nix' in repo root.
{ lib, ... }:
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
    };
  };
in
{
  options = {
    machine = lib.mkOption {
      type = machineSubmodule;
    };
  };
}
