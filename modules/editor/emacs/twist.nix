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
  den.aspects.emacs-twist.emacs-twist =
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
          defaultEditor.enable = lib.mkDefault true;
        };
        serviceIntegration.enable = true;
        emacsclient.enable = true;
      };
    };
}
