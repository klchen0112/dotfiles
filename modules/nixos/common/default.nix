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
    ./stylix.nix
  ];

  environment.systemPackages = with pkgs; [
    git
  ];

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}
