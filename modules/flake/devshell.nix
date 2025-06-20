{ inputs, ... }:
{
  imports = [
    inputs.git-hooks.flakeModule
    inputs.treefmt-nix.flakeModule
  ];
  perSystem =
    {
      inputs',
      config,
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "nixos-config-shell";
        meta.description = "Dev environment for nixos-config";
        packages = with pkgs; [
          just
          colmena
          nixd
          nix-output-monitor
          inputs'.agenix.packages.default
          nixfmt-rfc-style
          omnix
        ];
      };
      pre-commit.settings = {
        hooks.nixfmt-rfc-style.enable = true;
      };
      treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
        programs.nixfmt.package = pkgs.nixfmt-rfc-style;
        programs.shellcheck.enable = true;
        programs.deno.enable = true;
        programs.ruff.check = true;
        programs.ruff.format = true;
        programs.toml-sort.enable = true;
        settings.formatter.shellcheck.options = [
          "-s"
          "bash"
        ];
      };
    };
}
