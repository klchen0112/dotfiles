{
  den.aspects.network.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ifstat-legacy
      ];
    };
  den.aspects.network.nixos =
    { lib, ... }:
    {
      networking.useDHCP = lib.mkDefault true;
      networking.networkmanager = {
        enable = lib.mkDefault true;

      };
    };

}
