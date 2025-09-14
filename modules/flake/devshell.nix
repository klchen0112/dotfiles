{
  perSystem =
    { pkgs, inputs', ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "nixos-config-shell";
        meta.description = "Dev environment for nixos-config";
        packages = with pkgs; [
          just
          nixd
          nix-output-monitor
          inputs'.agenix.packages.default

          nixfmt-rfc-style
          neovim
          inputs'.allfollow.packages.default
          local.emacsIGC
        ];
      };
    };
}
