{ inputs, ... }:
{
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
          nixd
          nix-output-monitor
          inputs'.agenix.packages.default
          nixfmt-rfc-style
          neovim
          lua-language-server
          inputs'.allfollow.packages.default
        ];
      };
    };
}
