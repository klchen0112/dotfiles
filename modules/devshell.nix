{ inputs, ... }:
{
  imports = [
    inputs.devshell.flakeModule
  ];

  flake-file.inputs = {
    devshell = {
      url = "github:numtide/devshell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };

    };
  };

  perSystem =
    { pkgs, ... }:
    {
      checks = {

      };
      devShells.default = pkgs.mkShell {
        name = "nixos-config-shell";
        meta.description = "Dev environment for nixos-config";
        packages =
          with pkgs;
          [
            just
            nil
            nix-output-monitor
            git
          ]
          ++ (lib.optional pkgs.stdenv.isLinux [
            deploy-rs.deploy-rs

          ]);
      };
    };
}
