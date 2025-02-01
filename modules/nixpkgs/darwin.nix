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
  nix.gc =  {
      # Garbage collection
      automatic = true;
      interval = {
        Hour = 3;
        Minute = 15;
      };
      user = "${username}";
    };
  nix.optimise.interval =  {
        Hour = 3;
        Minute = 15;
      };
  nix.optimise.user = "${username}";
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  programs.nix-index.enable = true;
  services.nix-daemon.enable = true; # Auto upgrade daemon
}
