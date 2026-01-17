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
    nixpkgs.url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=nixos-unstable"; # Nix Packages
    nixpkgs-unstable.url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=nixpkgs-unstable"; # Nix Packages
    nixpkgs-stable.url = "git+https://github.com/nixos/nixpkgs?shallow=1&ref=release-25.11"; # Nix Packages
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
          allowUnfree = true;
          allowUnsupportedSystem = true;
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
          inputs.nix-vscode-extensions.overlays.default
          inputs.self.overlays.default
          inputs.emacs-config.overlays.default
          inputs.firefox-addons.overlays.default
          inputs.deploy-rs.overlays.default
          inputs.agenix.overlays.default
          inputs.chinese-fonts-overlay.overlays.default
        ];
      };
      pkgsDirectory = ../../pkgs/by-name;
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
