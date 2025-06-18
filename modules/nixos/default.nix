{
  flake,
  ...
}:
{
  imports = [
    ./common
    ./access-tokens.nix
    ./fonts
    ./stylix.nix
    ./hardware
  ];
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };
}
