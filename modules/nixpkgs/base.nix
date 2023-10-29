{ inputs
, outputs
, config
, pkgs
, username
, system
, ...
}:
{
  nix = {
    package = pkgs.nix;
    gc = {
      # Garbage collection
      automatic = true;
      options = "--delete-older-than 7d";

    };
    settings = {
      auto-optimise-store = true;
      trusted-users =
        [
          "${username}"
        ];
      experimental-features = [ "nix-command" "flakes" ];
      builders-use-substitutes = true;
    };
  };
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      # inputs.nixpkgs-firefox-darwin.overlay

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];

    config = {
      allowUnfree = true; # Allow proprietary software.
      allowUnfreePredicate = (_: true);
      #  allowUnsupportedSystem = true;
      #  allowBroken = true;
    };
  };
}
