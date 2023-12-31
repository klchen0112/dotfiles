{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  ...
}: {
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      inputs.emacs-overlay.overlays.default
      inputs.nixpkgs-wayland.overlay
      inputs.hyprpaper.overlays.default
      inputs.hyprpicker.overlays.default
      inputs.hyprcontrib.overlays.default
      inputs.devenv.overlays.default
      # neovim-nightly-overlay.overlays.default
      # inputs.nixpkgs-firefox-darwin.overlay
      inputs.nur.overlay
      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];

    config = {
      allowUnfree = true; # Allow proprietary software.
      allowUnfreePredicate = _: true;
      allowUnsupportedSystem = true;
      #  allowBroken = true;
      # for wechat uos
      permittedInsecurePackages = [
        "zotero-6.0.27"
      ];
    };
  };
}
