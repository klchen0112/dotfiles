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
        hooks.nixfmt.enable = true;
      };
      treefmt = {
        projectRootFile = "flake.nix";
        enableDefaultExcludes = true;
        programs.nixfmt.enable = true;
        programs.nixfmt.package = pkgs.nixfmt;
        programs.shellcheck.enable = true;
        programs.stylua.enable = true;
        programs.toml-sort.enable = true;
        programs.clang-format.enable = true;
        programs.just.enable = true;

        programs.ruff-format.enable = true;
        settings.global.excludes = [
          "*.org"
          "*.png"
          "*.conf"
          "*rc"
          "*/makefile"
          "*.age"
        ];
        settings.global.on-unmatched = "warn";
      };
    };
}
