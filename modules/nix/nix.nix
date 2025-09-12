let
  cfg =
    {
      inputs,
      pkgs,
      lib,
      ...
    }:
    {
      nixpkgs = {
        config = {
          allowBroken = true;
          allowUnsupportedSystem = true;
          allowUnfree = true;
        };
      };
      nix = {
        channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.
        nixPath = [
          "nixpkgs=${inputs.nixpkgs}"
          "nixpkgs-unstable=${inputs.nixpkgs-unstable}"
          "nixpkgs-stable=${inputs.nixpkgs-stable}"
        ]; # Enables use of `nix-shell -p ...` etc
        registry = {
          nixpkgs.flake = inputs.nixpkgs;
          nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
          nixpkgs-stable.flake = inputs.nixpkgs-stable;
        };
        settings = {
          max-jobs = "auto";
          # I don't have an Intel mac.
          extra-platforms = lib.mkIf pkgs.stdenv.isDarwin "aarch64-darwin x86_64-darwin";
          extra-experimental-features = "nix-command flakes";
          accept-flake-config = true;
        };

      };

    };
in
{
  flake.modules.homeManager.nix = cfg;
  flake.modules.darwin.nix = cfg;
  flake.modules.linux.nix = cfg;

}
