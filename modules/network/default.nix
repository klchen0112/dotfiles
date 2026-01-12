{
  flake.modules.homeManager.network =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ifstat-legacy
      ];
    };
  flake.modules.nixos.network =
    { lib, ... }:
    {
      networking.useDHCP = lib.mkDefault true;
      networking.networkmanager = {
        enable = lib.mkDefault true;

      };
    };

}
