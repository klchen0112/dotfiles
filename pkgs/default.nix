# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  inputs,
  pkgs,
}:
rec {
  # example = pkgs.callPackage ./example { };
  TsangerJinKai02 = pkgs.callPackage ./TsangerJinKai02 { };
  Jigmo = pkgs.callPackage ./Jigmo { };
  mps-darwin = pkgs.callPackage ./mps-darwin { };
  # this code from https://github.com/dezzw/demacs/blob/main/flake.nix
  emacsIGC =
    (inputs.emacs-overlay.packages.${pkgs.system}.emacs-git.override {
      withMailutils = false;
    }).overrideAttrs
      (old: rec {
        name = "emacs-${version}";
        version = "igc-2025-05-12";
        src = pkgs.fetchFromGitHub {
          owner = "emacs-mirror";
          repo = "emacs";
          rev = "2ef5b055f50d61fea59b54f87dbfd548e7a8b53d";
          hash = "sha256-k+KFWOPHmtXONK91TGzOmwLCNerUWNcmF9hXc3I5s4A=";
        };
        configureFlags = (old.configureFlags or [ ]) ++ [
          # "--with-xwidgets" # withXwidgets failed with mps enabled
          "--with-mps=yes"
        ];
        buildInputs = old.buildInputs ++ [ mps-darwin ];
        patches =
          (old.patches or [ ])
          ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [
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
            # ./system-appearance.patch
            (pkgs.fetchpatch {
              url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/emacs-31/system-appearance.patch";
              sha256 = "sha256-8pjPqtcwpDvA+xGAixB8eDEz2zD4Q6wzJ6G2iO5x0yc=";
            })
            # alpha-background
            ./ns-alpha-background.patch
            # ns-mac-input-source
            (pkgs.fetchpatch {
              url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/emacs-31/ns-mac-input-source.patch";
              sha256 = "sha256-E9BR/axZMhA3QTeoHIKU62Rogr7ZmTtWpnYdi69npNM=";
            })
          ]);

        meta.platforms = pkgs.lib.platforms.darwin ++ pkgs.lib.platforms.linux;
        meta.mainProgram = "emacs";
      });

  firefox-addons = pkgs.recurseIntoAttrs (pkgs.callPackage ./firefox-addons { });

}
