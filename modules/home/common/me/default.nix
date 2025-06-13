# User configuration module
{ config, lib, ... }:
{
  options = {
    me = {
      username = lib.mkOption {
        type = lib.types.str;
        description = "Your username as shown by `id -un`";
      };
      fullname = lib.mkOption {
        type = lib.types.str;
        description = "Your full name for use in Git config";
      };
      initialHashedPassword = lib.mkOption {
        type = lib.types.str;
      };
      email = lib.mkOption {
        type = lib.types.str;
        description = "Your email for use in Git config";
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
      root = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
  config = {
    home.username = config.me.username;
  };
}
