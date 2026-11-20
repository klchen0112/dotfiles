{ inputs, ... }:
let
  cfg =
    {
      pkgs,
      lib,
      ...
    }:
    {
      nixpkgs = {
        config = {
          allowUnfree = true;
          allowUnsupportedSystem = false;
          # lutris 0.5.22's FHS env still pulls gtk2, which nixpkgs now flags as
          # broken (removal planned for NixOS 27.05).
          # https://github.com/NixOS/nixpkgs/issues/410814
          problems.handlers."gtk+".broken = "warn";
        };
      };
      nix = {

        # registry = {
        #   nixpkgs.flake = inputs.nixpkgs;
        #   nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
        #   nixpkgs-stable.flake = inputs.nixpkgs-stable;
        # };
        settings = {
          max-jobs = "auto";
          # I don't have an Intel mac.
          extra-platforms = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "aarch64-darwin x86_64-darwin";
          extra-experimental-features = "nix-command flakes";
          accept-flake-config = true;
          nix-path = [
            "nixpkgs=${inputs.nixpkgs}"
            "nixpkgs-unstable=${inputs.nixpkgs-unstable}"
            "nixpkgs-stable=${inputs.nixpkgs-stable}"
          ]; # Enables use of `nix-shell -p ...` etc

        };

      };

    };
in
{
  den.aspects.nix-home.homeManager = cfg;
  den.aspects.nix = {
    darwin = cfg;
    nixos = cfg;
  };
}
