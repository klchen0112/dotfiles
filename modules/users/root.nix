{ config, ... }:
{

  flake.modules.nixos.root =
    { ... }:
    {
      nix.settings.trusted-users = [ "root" ];
      users.users.root = {
        isNormalUser = false;
        initialHashedPassword = config.flake.meta.users.klchen.initialHashedPassword;
      };
      services.openssh.settings.AllowUsers = [ "root" ];
    };
}
