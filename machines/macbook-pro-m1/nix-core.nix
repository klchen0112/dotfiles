{ inputs
, outputs
, config
, pkgs
, username
, system
, ...
}:
{
  services.nix-daemon.enable = true; # Auto upgrade daemon
  nix = {
    package = pkgs.nix;
    gc = {
      # Garbage collection
      automatic = true;
      interval.Day = 7;
      options = "--max-freed $((64 * 1024**3))";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      auto-optimise-store = true;
      trusted-users =
        [
          "${username}"
        ];
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
