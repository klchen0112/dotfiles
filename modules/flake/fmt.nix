{ inputs, ... }:
{
  flake-file.inputs = {
    git-hooks.url = "github:cachix/git-hooks.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";

  };
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks.flakeModule
  ];
  perSystem =
    {
      ...
    }:
    {
      pre-commit.settings = {
        hooks.nixfmt-rfc-style.enable = true;
      };
      treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
        programs.shellcheck.enable = true;
        programs.deno.enable = true;
        programs.ruff.check = true;
        programs.ruff.format = true;
        programs.toml-sort.enable = true;
        programs.stylua.enable = true;
        settings.formatter.shellcheck.options = [
          "-s"
          "bash"
        ];
        settings.global.excludes = [
          ".envrc"
          "Justfile"
          "*.org"
          "*.png"
          "*rc"
          "*.conf"
          "*/packages/*"

        ];
      };
    };
}
