{ inputs, ... }:
{
  den.aspects.nix = {

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
  

      };
    nixos = {
      programs.nix-ld.enable = true;

    };
    os = {
      environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
      nixpkgs.overlays = [
        inputs.self.overlays.default
      ];
    };

  };
}
