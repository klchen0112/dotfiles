{
  stdenv,
  fetchpatch,
  lib,
  mps,
  fetchFromGitHub,
  emacs-overlay,
}:
(emacs-overlay.packages.${stdenv.system}.emacs-git.override {
  withMailutils = false;
  withPgtk = stdenv.hostPlatform.isLinux;
}).overrideAttrs
  (old: rec {
    name = "emacs-${version}";
    version = "igc-2025-06-25";
    src = fetchFromGitHub {
      owner = "emacs-mirror";
      repo = "emacs";
      rev = "1c19182e28e90b619a4c3d5553e3b5ae03eccd12";
      hash = "sha256-nZIcNLpe6qqyxZMsm8e5jup2HHHaWbgIk36MstxoTjc=";
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
