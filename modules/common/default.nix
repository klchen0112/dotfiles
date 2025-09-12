{
  flake.modules.nixos.common =
    {
      pkgs,
      ...
    }:
    {

      environment.systemPackages = with pkgs; [
        gitFull
      ];

      home-manager.useUserPackages = true;
      home-manager.useGlobalPkgs = true;
    };
}
