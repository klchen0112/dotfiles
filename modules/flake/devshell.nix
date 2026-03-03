{
  perSystem =
    { pkgs, inputs', ... }:
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

            #          inputs'.allfollow.packages.default
          ]
          ++ (lib.optional pkgs.stdenv.isLinux [
            deploy-rs.deploy-rs

          ]);
      };
    };
}
