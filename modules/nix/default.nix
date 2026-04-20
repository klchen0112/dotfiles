{ inputs, den, ... }:
{
  den.aspects.nix-home = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          nixfmt
          nix-du
          nixd
          cachix
          # statix
          # deadnix
          nix-fast-build
          devenv
        ];
        nixpkgs.overlays = [
          inputs.self.overlays.default
        ];
      };

  };
}
