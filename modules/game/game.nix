{ den, inputs, ... }:
{
  den.aspects.game = {
    nixos =
      { lib, pkgs, ... }:
      {
        programs.steam.enable = true;
        programs.steam.gamescopeSession.enable = true;

        environment.systemPackages = with pkgs; [
          mangohud
          protonup-ng
          lutris
        ];

        programs.gamemode.enable = true;


        #environment.sessionVariables = {
        #  STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
        #};

      };
    #     };
  };

}
