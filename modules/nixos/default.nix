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
    flake.inputs.stylix.nixosModules.stylix
  ];
  services.openssh.enable = true;
}
