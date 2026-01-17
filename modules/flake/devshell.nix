{
  perSystem =
    { pkgs, inputs', ... }:
    {
      checks = {

      };
      devShells.default = pkgs.mkShell {
        name = "nixos-config-shell";
        meta.description = "Dev environment for nixos-config";
        packages = with pkgs; [
          just
          nixd
          nix-output-monitor
          agenix
          deploy-rs.deploy-rs

          #          inputs'.allfollow.packages.default
        ];
      };
    };
}
