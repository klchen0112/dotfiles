{
  flake,
  ...}
  :{
  imports = [
    ./common
    ./linux/access-tokens.nix
    ./linux/fonts
    ./stylix.nix
    flake.inputs.stylix.nixosModules.stylix
  ];
  services.openssh.enable = true;
}
