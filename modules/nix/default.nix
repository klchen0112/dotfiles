{ inputs, den, ... }:
{
  den.aspects.nix = {
    includes = [
      den.provides.mutual-provider
    ];
    provides.to-users.homeManager =
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
    nixos = {
      programs.nix-ld.enable = true;
    };
    os = {
      environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";
    };

  };
}
