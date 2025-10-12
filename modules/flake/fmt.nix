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
    inputs.git-hooks.flakeModule
  ];
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      pre-commit.settings = {
        hooks.nixfmt-rfc-style.enable = true;
      };
      treefmt = {
        projectRootFile = "flake.nix";
        enableDefaultExcludes = true;
        programs.nixfmt.enable = true;
        programs.nixfmt.package = pkgs.nixfmt-rfc-style;
        programs.shellcheck.enable = true;
        settings.global.excludes = [
          "Justfile"
          "*.org"
          "*.png"
        ];
        settings.global.on-unmatched = "warn";
      };
    };
}
