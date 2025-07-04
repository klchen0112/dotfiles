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
    # package = pkgs.brewCasks.hammerspoon; # using brew-nix for nix derivation translation from homebrew api

    ## Optional: Path to your Hammerspoon configuration (init.lua or a directory)
    # configPath = ./path/to/your/hammerspoon/config;

    # Optional: Install Hammerspoon Spoons
    spoons = {
      "PaperWM.spoon" = pkgs.fetchFromGitHub {
        owner = "mogenson";
        repo = "PaperWM.spoon";
        rev = "e47ca19eddb1cb6000415a6a61db7255162f4cdb";
        sha256 = "sha256-9M2b1rMyMzJK0eusea0x3lyh3mu5nMeEDSc4RZkGm+g=";
      };
    };
  };
}
