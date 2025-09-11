{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks.flakeModule
  ];
  perSystem =
    {
      self,
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
      };
    };
}
