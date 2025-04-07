# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  inputs,
  pkgs,
}:
rec {
  # example = pkgs.callPackage ./example { };
  TsangerJinKai02 = inputs.own-nur.packages.${pkgs.system}.TsangerJinKai02;
  Jigmo = inputs.own-nur.packages.${pkgs.system}.Jigmo;
  mamba-cpp = inputs.own-nur.packages.${pkgs.system}.mamba-cpp;
  # this code from https://github.com/dezzw/demacs/blob/main/flake.nix

  emacsPlusMaster = inputs.emacs-overlay.packages.${pkgs.system}.emacs-git.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      # Fix OS window role (needed for window managers like yabai)
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
        sha256 = "+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
      })
      # Enable rounded window with no decoration
      # (pkgs.fetchpatch {
      #   url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-31/round-undecorated-frame.patch";
      #   sha256 = "iMn/aYtTKyJx3k1n2kVYU0TdriIFPjYSmKh9mEdXrpE=";
      # })
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
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/ns-alpha-background.patch";
        sha256 = "sha256-sJ74+0jshtt0KwASHrn23ZlIOPr4zy47Dh05UDic62s=";
      })
      # ns-mac-input-source
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/ns-mac-input-source.patch";
        sha256 = "sha256-E9BR/axZMhA3QTeoHIKU62Rogr7ZmTtWpnYdi69npNM=";
      })
    ];
    meta.platforms = pkgs.lib.platforms.darwin;
    meta.mainProgram = "emacs";
  });
  emacsPlus30 = inputs.emacs-overlay.packages.${pkgs.system}.emacs-unstable.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      # Fix OS window role (needed for window managers like yabai)
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
        sha256 = "+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
      })
      # Enable rounded window with no decoration
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/round-undecorated-frame.patch";
        sha256 = "uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
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
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/sincebyte/neo-emacs/master/patches/emacs30/ns-alpha-background.patch";
        sha256 = "sha256-3OG1tMpg/1jrP/gsnFCkqJ22OkS/d8voOUqiOk7iUkE=";
      })
      # ns-mac-input-source
      (pkgs.fetchpatch {
        url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/ns-mac-input-source.patch";
        sha256 = "sha256-E9BR/axZMhA3QTeoHIKU62Rogr7ZmTtWpnYdi69npNM=";
      })
    ];
    meta.platforms = pkgs.lib.platforms.darwin;
    meta.mainProgram = "emacs";
  });
  emacsIGC =
    (inputs.emacs-overlay.packages.${pkgs.system}.emacs-git.override {
      withMailutils = false;
    }).overrideAttrs
      (old: rec {
        name = "emacs-${version}";
        version = "igc-2025-04-05";
        src = pkgs.fetchFromGitHub {
          owner = "emacs-mirror";
          repo = "emacs";
          rev = "8f222220b378fa60f64eeb29a00ffb0a1d7c4dfe";
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
