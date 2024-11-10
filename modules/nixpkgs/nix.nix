{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  ...
}: {
  nix = {
    package = pkgs.nixVersions.latest;
    gc = {
      # Garbage collection
      automatic = true;
      options = "--delete-older-than 7d";

      # interval = {
      # Hour = 3;
      # Minute = 15;
      # };
    };
    optimise = {
      automatic = true;
      # options = "--delete-older-than 7d";
    };
    settings = {
      trusted-users = ["${username}"];
      experimental-features = ["nix-command" "flakes"];
      builders-use-substitutes = true;
    };
  };
}
