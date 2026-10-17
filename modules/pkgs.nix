{
  inputs,
  withSystem,
  ...
}:
{
  flake-file.inputs = {
    pkgs-by-name-for-flake-parts = {
      url = "github:drupol/pkgs-by-name-for-flake-parts";
    };
    # Determinate Systems' weekly-updated nixpkgs (NixOS Weekly): one bump per week,
    # each revision adopted only after a 7-day cooldown. Published on FlakeHub.
    nixpkgs.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0.1"; # Nix Packages
    nixpkgs-unstable.url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=nixpkgs-unstable"; # Nix Packages
    nixpkgs-stable.url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=release-26.05"; # Nix Packages
  };
  imports = [
    inputs.pkgs-by-name-for-flake-parts.flakeModule
  ];

  perSystem =
    {
      system,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          cudaSupport = true;
          allowUnfree = true;
          allowUnsupportedSystem = false;
          cudaVersion = "13";
        };
        overlays = [
          (final: _prev: {
            stable = import inputs.nixpkgs-stable {
              inherit (final) config;
              inherit system;
            };
          })
          (final: _prev: {
            unstable = import inputs.nixpkgs-unstable {
              inherit (final) config;
              inherit system;
            };
          })

          # inputs.emacs-config.overlays.default
          inputs.deploy-rs.overlays.default
          # inputs.agenix.overlays.default
          # inputs.chinese-fonts-overlay.overlays.default
        ];
      };
      pkgsDirectory = ../pkgs/by-name;
      pkgsNameSeparator = "-";
    };
  flake = {
    overlays.default =
      _final: prev:
      withSystem prev.stdenv.hostPlatform.system (
        { config, ... }:
        {
          local = config.packages;
        }
      );
  };
}
