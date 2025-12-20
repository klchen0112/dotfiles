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
      networking.useDHCP = lib.mkForce true;
      networking.dhcpcd.enable = true;
      networking.networkmanager = {
        enable = true;

      };
    };

}
