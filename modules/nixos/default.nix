{
  flake,
  ...}
  :{
  imports = [
    ./common
    ./access-tokens.nix
    ./fonts
    ./stylix.nix
    flake.inputs.stylix.nixosModules.stylix
  ];
  services.openssh.enable = true;
}
