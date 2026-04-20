{ config, ... }:
{

  den.aspects.root.nixos =
    { ... }:
    {
      nix.settings.trusted-users = [ "root" ];
      users.users.root = {
        isSystemUser = true;
        initialHashedPassword = "$y$j9T$WX1yl8edHz32y77s640GV.$M1U0keGszxKa9efTMnTG/VJAIOqtDj0mPEToL6cBF13";
      };
      services.openssh.settings.AllowUsers = [ "root" ];
    };
}
