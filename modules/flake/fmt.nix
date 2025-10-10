{ inputs, ... }:
{
  flake-file.inputs = {
    git-hooks = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:cachix/git-hooks.nix";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  imports = [
    inputs.treefmt-nix.flakeModule
    #   inputs.git-hooks.flakeModule
  ];
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      #     pre-commit.settings = {
      #       hooks.nixfmt-rfc-style.enable = true;
      #     };
      treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = pkgs.lib.meta.availableOn pkgs.stdenv.buildPlatform pkgs.nixfmt-rfc-style.compiler;
        programs.nixfmt.package = pkgs.nixfmt-rfc-style;
      };
    };
}
