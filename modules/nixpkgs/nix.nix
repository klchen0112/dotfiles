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
