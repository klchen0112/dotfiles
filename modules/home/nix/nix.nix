{
  flake,
  pkgs,
  lib,
  config,
  ...
}:
{
  nix = {
    config = {
      allowBroken = true;
      allowUnsupportedSystem = true;
      allowUnfree = true;
    };
    nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
    registry = {
      nixpkgs.flake = flake.inputs.nixpkgs;
      nixpkgs-unstable.flake = flake.inputs.nixpkgs-unstable;
    };
    gc.automatic = true;
    settings = {
      max-jobs = "auto";
      # I don't have an Intel mac.
      extra-platforms = lib.mkIf pkgs.stdenv.isDarwin "aarch64-darwin x86_64-darwin";
      extra-experimental-features = "nix-command flakes";
      accept-flake-config = true;
    };

  };

}
