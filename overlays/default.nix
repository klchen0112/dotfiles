{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
  packages = self + /packages;
in
self: super: rec {
  omnix = inputs.omnix.packages.${self.system}.default;
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
        version = "igc-2025-06-01";
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
              url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/emacs-31/fix-window-role.patch";
              sha256 = "0ib2CXtDI7yeD/VpB9QFrHWtsVciU8G3h6oUGu6X2Zc=";
            })
            # Enable rounded window with no decoration
            (self.fetchpatch {
              url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/emacs-31/round-undecorated-frame.patch";
              sha256 = "fiUZ+4yHdz0lWYd4rsUxgDwmQxgQFQ3UW1LQRfn2puM=";
            })
            # Make Emacs aware of OS-level light/dark mode
            (self.fetchpatch {
              url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/emacs-31/system-appearance.patch";
              sha256 = "sha256-8pjPqtcwpDvA+xGAixB8eDEz2zD4Q6wzJ6G2iO5x0yc=";
            })
            # alpha-background
            (self.fetchpatch {
              url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/emacs-31/ns-alpha-background.patch";
              sha256 = "sha256-sJ74+0jshtt0KwASHrn23ZlIOPr4zy47Dh05UDic62s=";
            })
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
