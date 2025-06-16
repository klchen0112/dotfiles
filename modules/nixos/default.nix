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
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "no";
  };
}
