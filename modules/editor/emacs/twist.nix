{ inputs, ... }:
{
  flake-file.inputs = {
    emacs-config = {
      url = "github:klchen0112/emacs-config";
      inputs.twist.follows = "twist";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    twist.url = "github:emacs-twist/twist.nix";
  };
  flake.modules.homeManager.emacs-twist =
    {
      pkgs,
      ...
    }:
    {
      imports = [ inputs.emacs-config.homeModules.twist ];
      programs.emacs-twist = {
        enable = true;
        settings = {
          extraFeatures = [
          ];
        };
      };
      services.emacs = {
        enable = true;
        client.enable = true;
        socketActivation.enable = true;
        startWithUserSession = "graphical";
      };
    };
}
