{
  pkgs,
  config,
  ...
}:
{
  imports = [ ./modules ];
  programs.hammerspoon = {
    enable = true; # enable the Hammerspoon module

    ## Optional: Hammerspoon package
    package = pkgs.brewCasks.hammerspoon; # using brew-nix for nix derivation translation from homebrew api

    ## Optional: Path to your Hammerspoon configuration (init.lua or a directory)
    configPath = ./config;

    # Optional: Install Hammerspoon Spoons
    spoons = {
      "PaperWM" = pkgs.fetchFromGitHub {
        owner = "mogenson";
        repo = "PaperWM.spoon";
        rev = "e47ca19eddb1cb6000415a6a61db7255162f4cdb";
        sha256 = "sha256-9M2b1rMyMzJK0eusea0x3lyh3mu5nMeEDSc4RZkGm+g=";
      };
      "Swipe" = pkgs.fetchFromGitHub {
        owner = "mogenson";
        repo = "Swipe.spoon";
        rev = "c56520507d98e663ae0e1228e41cac690557d4aa";
        sha256 = "sha256-9M2b1rMyMzJK0eusea0x3lyh3mu5nMeEDSc4RZkGm+g=";
      };
      "ActiveSpace" = pkgs.fetchFromGitHub {
        owner = "mogenson";
        repo = "ActiveSpace.spoon";
        rev = "94d2f7e5c6bcab0410d10578482c2553488d7e5d";
        sha256 = "sha256-9M2b1rMyMzJK0eusea0x3lyh3mu5nMeEDSc4RZkGm+g=";
      };
      "WarpMouse" = pkgs.fetchFromGitHub {
        owner = "mogenson";
        repo = "WarpMouse.spoon";
        rev = "d970cdf920521fa9ffd579fade0efd7c572e070f";
        sha256 = "sha256-9M2b1rMyMzJK0eusea0x3lyh3mu5nMeEDSc4RZkGm+g=";
      };

    };
  };
}
