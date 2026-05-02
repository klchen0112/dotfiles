{ den, inputs, ... }:
{
  den.aspects.game = {
    nixos =
      { lib, pkgs, ... }:
      {
#        specialisation.gaming-time.configuration = {
            programs.steam.enable = true;
            programs.steam.gamescopeSession.enable = true;

            environment.systemPackages = with pkgs; [
              mangohud
              protonup-ng
              lutris
            ];

            programs.gamemode.enable = true;

            hardware.nvidia = {
              prime.sync.enable = lib.mkForce true;
              prime.offload = {
                enable = lib.mkForce false;
                enableOffloadCmd = lib.mkForce false;
              };
            };

            #environment.sessionVariables = {
            #  STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
            #};

          };
 #     };
  };

}
