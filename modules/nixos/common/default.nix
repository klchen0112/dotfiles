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
  environment.systemPackages = with pkgs; [ git ];
}
