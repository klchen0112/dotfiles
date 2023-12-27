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
    package = pkgs.nix;
    gc = {
      # Garbage collection
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "${username}"
      ];
      experimental-features = ["nix-command" "flakes"];
      builders-use-substitutes = true;
    };
  };
}
