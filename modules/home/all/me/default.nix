# User configuration module
{ config, lib, ... }:
{
  options = {
    me = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Your username as shown by `id -un`";
      };
      # fullname = lib.mkOption {
      #   type = lib.types.str;
      #   description = "Your full name for use in Git config";
      # };
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
    };
  };
  config = {
    home.username = config.me.name;
  };
}
