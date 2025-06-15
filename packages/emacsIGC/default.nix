{
  stdenv,
  fetchpatch,
  lib,
  mps,
  fetchFromGitHub,
  emacs-overlay
}:
(emacs-overlay.packages.${stdenv.system}.emacs-git.override {
  withMailutils = false;
}).overrideAttrs
  (old: rec {
    name = "emacs-${version}";
    version = "igc-2025-06-15";
    src = fetchFromGitHub {
      owner = "emacs-mirror";
      repo = "emacs";
      rev = "08a7477d2205f4f4a9c6bcc184fdea060c33474b";
      hash = "sha256-whRv/sLJ+wY07aCdN4T8C6tIjL0yHuLjvVwxUVAsjLY=";
    };
    configureFlags = (old.configureFlags or [ ]) ++ [
      # "--with-xwidgets" # withXwidgets failed with mps enabled
      "--with-mps=yes"
    ];
    buildInputs = old.buildInputs ++ [ mps ];
    patches =
      (old.patches or [ ])
      ++ (lib.optionals stdenv.isDarwin [
        # Fix OS window role (needed for window managers like yabai)
        (fetchpatch {
          url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/emacs-31/fix-window-role.patch";
          sha256 = "0ib2CXtDI7yeD/VpB9QFrHWtsVciU8G3h6oUGu6X2Zc=";
        })
        # Enable rounded window with no decoration
        (fetchpatch {
          url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/emacs-31/round-undecorated-frame.patch";
          sha256 = "fiUZ+4yHdz0lWYd4rsUxgDwmQxgQFQ3UW1LQRfn2puM=";
        })
        # Make Emacs aware of OS-level light/dark mode
        (fetchpatch {
          url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/emacs-31/system-appearance.patch";
          sha256 = "sha256-8pjPqtcwpDvA+xGAixB8eDEz2zD4Q6wzJ6G2iO5x0yc=";
        })
        # alpha-background
        (fetchpatch {
          url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/emacs-31/ns-alpha-background.patch";
          sha256 = "sha256-sJ74+0jshtt0KwASHrn23ZlIOPr4zy47Dh05UDic62s=";
        })
        # ns-mac-input-source
        (fetchpatch {
          url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/emacs-31/ns-mac-input-source.patch";
          sha256 = "sha256-E9BR/axZMhA3QTeoHIKU62Rogr7ZmTtWpnYdi69npNM=";
        })
      ]);

    meta.platforms = lib.platforms.darwin ++ lib.platforms.linux;
    meta.mainProgram = "emacs";
  })
