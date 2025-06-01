# Make flake.config.peope.myself the admin of the machine
{ flake
, pkgs
, lib
, ...
}:

{
  # Login via SSH with mmy SSH key
  users.users =
    let
      me = flake.config.me;
      myKeys = [
        me.sshKey
      ];
    in
    {
      root.openssh.authorizedKeys.keys = myKeys;
      ${me.name} =
        {
          openssh.authorizedKeys.keys = myKeys;
          shell = if pkgs.stdenv.isLinux then pkgs.bash else pkgs.zsh;
        }
        // lib.optionalAttrs pkgs.stdenv.isLinux {
          isNormalUser = true;
          extraGroups = [
            "networkmanager"
            "wheel"
          ];
        };
    };

  programs.bash.enable = lib.mkIf pkgs.stdenv.isLinux true;

  # Make me a sudoer without password
  security = lib.optionalAttrs pkgs.stdenv.isLinux {
    sudo.execWheelOnly = true;
    sudo.wheelNeedsPassword = false;
  };
}
