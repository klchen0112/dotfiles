{ config, ... }:
{

  flake.modules.nixos.root =
    { ... }:
    {
      nix.settings.trusted-users = [ "root" ];
      users.users.root = {
        isNormalUser = false;
        openssh.authorizedKeys.keys = config.flake.meta.users.klchen.authorizedKeys;
        initialHashedPassword = config.flake.meta.users.klchen.initialHashedPassword;
      };
    };
}
