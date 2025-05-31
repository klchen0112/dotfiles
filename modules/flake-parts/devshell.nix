{ inputs, ... }:
{
  imports = [
    inputs.git-hooks.flakeModule
    inputs.treefmt-nix.flakeModule
  ];
  perSystem = { inputs', config, pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      name = "nixos-config-shell";
      meta.description = "Dev environment for nixos-config";
      inputsFrom = [ config.pre-commit.devShell ];
      packages = with pkgs; [
        just
        colmena
        nixd
        nix-output-monitor
        inputs'.agenix.packages.default
      ];
    };
    pre-commit.settings.hooks = {
      nixpkgs-fmt.enable = true;
    };
     treefmt = {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = pkgs.lib.meta.availableOn pkgs.stdenv.buildPlatform pkgs.nixfmt-rfc-style.compiler;
        programs.nixfmt.package = pkgs.nixfmt-rfc-style;
        programs.shellcheck.enable = true;
        programs.deno.enable = true;
        programs.ruff.check = true;
        programs.ruff.format = true;
        settings.formatter.shellcheck.options = [
          "-s"
          "bash"
          ];
      };
  };
}
