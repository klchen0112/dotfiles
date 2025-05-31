{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
  packages = self + /packages;
in
self: super: rec {
  nuenv = (inputs.nuenv.overlays.nuenv self super).nuenv;
  # fuckport = self.callPackage "${packages}/fuckport.nix" { };
  # twitter-convert = self.callPackage "${packages}/twitter-convert" { };
  # sshuttle-via = self.callPackage "${packages}/sshuttle-via.nix" { };
  # copy-md-as-html = self.callPackage "${packages}/copy-md-as-html.nix" { };
  # ci = self.callPackage "${packages}/ci" { };
  # touchpr = self.callPackage "${packages}/touchpr" { };
  omnix = inputs.omnix.packages.${self.system}.default;
  # git-merge-and-delete = self.callPackage "${packages}/git-merge-and-delete.nix" { };
  TsangerJinKai02 = self.callPackage "${packages}/TsangerJinKai02" { };
  Jigmo = self.callPackage "${packages}/Jigmo" { };
  firefox-addons = self.recurseIntoAttrs (self.callPackage "${packages}/firefox-addons" { });
  mps-darwin = self.callPackage "${packages}/mps-darwin" { };
  emacsIGC =
    (inputs.emacs-overlay.packages.${self.system}.emacs-git.override {
      withMailutils = false;
    }).overrideAttrs
      (old: rec {
        name = "emacs-${version}";
        version = "igc-2025-05-27";
        src = self.fetchFromGitHub {
          owner = "emacs-mirror";
          repo = "emacs";
          rev = "200b02f54dac5db34496f35d0884f03afa23a5a6";
          hash = "sha256-xm5+SI2VfwVoMDR05m66+DCTuqLEzKe8Yul8Ytg3pw8=";
        };
        configureFlags = (old.configureFlags or [ ]) ++ [
          # "--with-xwidgets" # withXwidgets failed with mps enabled
          "--with-mps=yes"
        ];
        buildInputs = old.buildInputs ++ [ mps-darwin ];
        patches =
          (old.patches or [ ])
          ++ (self.lib.optionals self.stdenv.isDarwin [
            # Fix OS window role (needed for window managers like yabai)
            (self.fetchpatch {
              url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
              sha256 = "+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
            })
            # Enable rounded window with no decoration
            (self.fetchpatch {
              url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-31/round-undecorated-frame.patch";
              sha256 = "sha256-WWLg7xUqSa656JnzyUJTfxqyYB/4MCAiiiZUjMOqjuY=";
            })
            # Make Emacs aware of OS-level light/dark mode
            (self.fetchpatch {
              url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/emacs-31/system-appearance.patch";
              sha256 = "sha256-8pjPqtcwpDvA+xGAixB8eDEz2zD4Q6wzJ6G2iO5x0yc=";
            })
            # alpha-background
            ./ns-alpha-background.patch
            # ns-mac-input-source
            (self.fetchpatch {
              url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/emacs-31/ns-mac-input-source.patch";
              sha256 = "sha256-E9BR/axZMhA3QTeoHIKU62Rogr7ZmTtWpnYdi69npNM=";
            })
          ]);

        meta.platforms = self.lib.platforms.darwin ++ self.lib.platforms.linux;
        meta.mainProgram = "emacs";
      });
}
