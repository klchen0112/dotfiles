{
  pkgs,
  config,
  flake,
  lib,
  ...
}:
{
  imports = [ ./module ];

  programs.hammerspoon = {
    enable = true; # enable the Hammerspoon module

    ## Optional: Hammerspoon package
    package = pkgs.brewCasks.hammerspoon; # using brew-nix for nix derivation translation from homebrew api

    ## Optional: Path to your Hammerspoon configuration (init.lua or a directory)
    configPath = lib.cleanSource ./config;

    # Optional: Install Hammerspoon Spoons
    spoons = with pkgs.hammerspoons; [
      PaperWM
      ActiveSpace
      Swipe
      WarpMouse
    ];
  };
}
