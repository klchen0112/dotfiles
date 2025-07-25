{
  flake,
  pkgs,
  lib,
  config,
  ...
}:
{
  environment.etc."nix/inputs/nixpkgs".source = "${flake.inputs.nixpkgs}";

  nixpkgs = {
    config = {
      allowBroken = true;
      allowUnsupportedSystem = true;
      allowUnfree = true;
    };
    overlays = [
      flake.inputs.nix-vscode-extensions.overlays.default
      flake.inputs.nur.overlays.default
      flake.inputs.emacs-overlay.overlays.default
      # flake.inputs.self.overlays.default
    ] ++ (lib.attrValues flake.inputs.self.overlays);
  };
  nix = {
    channel.enable = false; # remove nix-channel related tools & configs, we use flakes instead.
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
