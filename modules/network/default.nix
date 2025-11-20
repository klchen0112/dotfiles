{
  flake.modules.homeManager.network =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ifstat-legacy
      ];
    };
  flake.modules.nixos.network =
    { ... }:
    {
      networking.networkmanager = {
        enable = true;

      };
    };

}
