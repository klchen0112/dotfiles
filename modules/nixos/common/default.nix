{
  pkgs,
  ...
}:
{
  imports = [
    ./nix.nix
    ./caches.nix
    ./myusers.nix
    ./fonts.nix
  ];

  environment.systemPackages = with pkgs; [
    gitFull
  ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}
