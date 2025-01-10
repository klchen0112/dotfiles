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
    channel.enable = false;
    gc = {
      # Garbage collection
      automatic = true;
      interval = {
        Hour = 3;
        Minute = 15;
      };
      user = "${username}";
    };
    optimise = {
      automatic = true;
      user = "${username}";
      interval = {
        Hour = 3;
        Minute = 15;
      };
      # options = "--delete-older-than 7d";
    };
    settings = {
      trusted-users = ["${username}"];
      experimental-features = ["nix-command" "flakes"];
      builders-use-substitutes = true;
    };
  };
}
