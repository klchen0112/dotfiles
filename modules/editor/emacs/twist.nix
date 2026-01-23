{ inputs, ... }:
{
  flake-file.inputs = {
    emacs-config = {
      url = "github:klchen0112/.emacs.d";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    emacs-overlay = {
      follows = "emacs-config/emacs-overlay";
    };
  };
  flake.modules.homeManager.emacs-twist =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ inputs.emacs-config.homeModules.twist ];
      home.packages = with pkgs; [ ] ++ (lib.optionals pkgs.stdenv.isDarwin [ local.org-reminders ]);
      programs.emacs-twist = {
        enable = true;
        settings = {
          enableDefaultEditor = true;
        };
      };
    };
}
