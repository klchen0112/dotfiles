{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  ...
}: {
  imports = [
    ./base.nix
    ./nix.nix
  ];
  nix.gc.interval = {
    Hour = 3;
    Minute = 15;
  };
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  programs.nix-index.enable = true;
  services.nix-daemon.enable = true; # Auto upgrade daemon
}
