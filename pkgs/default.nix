# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  inputs,
  pkgs,
}:
{
  # example = pkgs.callPackage ./example { };
  TsangerJinKai02 = inputs.own-nur.packages.${pkgs.system}.TsangerJinKai02;
  Jigmo = inputs.own-nur.packages.${pkgs.system}.Jigmo;
  # this code from https://github.com/dezzw/demacs/blob/main/flake.nix

  emacsIGC =
    (inputs.emacs-overlay.packages.${pkgs.system}.emacs-git.override {
      withMailutils = false;
    }).overrideAttrs
      (old: rec {
        name = "emacs-${version}";
        version = "igc-2025-04-15";
        src = pkgs.fetchFromGitHub {
          owner = "emacs-mirror";
          repo = "emacs";
          rev = "7b35a5062231ec5a11c7a87d4797cfb5dba25121";
          hash = "sha256-R+r28ahkW8Hl4sQVQfPxcsRnPdOoEdmmuF8H+T99pJ0=";
        };
        configureFlags = (old.configureFlags or [ ]) ++ [
          # "--with-xwidgets" # withXwidgets failed with mps enabled
          "--with-mps=yes"
        ];
        buildInputs = old.buildInputs ++ [ inputs.own-nur.packages.${pkgs.system}.mps-darwin ];
        patches = (old.patches or [ ]) ++ [
          # Fix OS window role (needed for window managers like yabai)
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
            sha256 = "+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
          })
          # Enable rounded window with no decoration
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-31/round-undecorated-frame.patch";
            sha256 = "sha256-WWLg7xUqSa656JnzyUJTfxqyYB/4MCAiiiZUjMOqjuY=";
          })
          # Make Emacs aware of OS-level light/dark mode
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/system-appearance.patch";
            sha256 = "sha256-3QLq91AQ6E921/W9nfDjdOUWR8YVsqBAT/W9c1woqAw=";
          })
          #Cursor animation
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/sincebyte/neo-emacs/master/patches/emacs31/cursor-animation.patch";
            sha256 = "sha256-xrg9iAl0ZrfqzCnq0oact5XozRYOY/rP/MO8QdbIkM0=";
          })
          # alpha-background
          ./ns-alpha-background.patch
          # ns-mac-input-source
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/ns-mac-input-source.patch";
            sha256 = "sha256-E9BR/axZMhA3QTeoHIKU62Rogr7ZmTtWpnYdi69npNM=";
          })
        ];

        meta.platforms = pkgs.lib.platforms.darwin;
        meta.mainProgram = "emacs";
      });
}
