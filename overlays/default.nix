# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev:
    import ../pkgs {
      pkgs = final;
      inherit inputs;
    };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    librime =
      (prev.librime.override {
        plugins = [
          (prev.pkgs.fetchFromGitHub {
            owner = "hchunhui";
            repo = "librime-lua";
            rev = "7be6974b6d81c116bba39f6707dc640f6636fa4e";
            fetchSubmodules = false;
            sha256 = "sha256-jsrnAFE99d0U0LdddTL7G1p416qJfSNR935TZFH3Swk=";
          })
          # TODO
          # (final.pkgs.fetchFromGitHub {
          #   owner = "rime";
          #   repo = "librime-predict";
          #   rev = "591c80a8d0481be99c44d008c15acd55074d8c68";
          #   sha256 = "sha256-77g72tee4ahNcu3hsW1Okqr9z8Y6WrPgUhw316O72Ng=";
          # })
          # (prev.pkgs.fetchFromGitHub {
          #   owner = "lotem";
          #   repo = "librime-octagram";
          #   rev = "bd12863f45fbbd5c7db06d5ec8be8987b10253bf";
          #   fetchSubmodules = false;
          #   sha256 = "sha256-77g72tee4ahNcu3hfW1Okqr9z8Y6WrPgUhw316O72Ng=";
          # })
        ];
      })
      .overrideAttrs (old: {
        buildInputs = (old.buildInputs or []) ++ [final.pkgs.luajit];
      });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
