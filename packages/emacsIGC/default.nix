{
  stdenv,
  fetchpatch,
  lib,
  mps,
  fetchFromGitHub,
  emacs-overlay,
}:
((emacs-overlay.packages.${stdenv.system}.emacs-igc).override ({
  withNativeCompilation = true;
  withMailutils = false;
})).overrideAttrs
  (old: rec {
    patches =
      (old.patches or [ ])
      ++ (lib.optionals stdenv.isDarwin [
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
          sha256 = "sha256-y5f8U36t3G2XQIDBu6vbHs7inCtrwhfgBzAANVBISO4=";
        })
        # ns-mac-input-source
        (fetchpatch {
          url = "https://raw.githubusercontent.com/LuciusChen/.emacs.d/refs/heads/main/patches/emacs-31/ns-mac-input-source.patch";
          sha256 = "sha256-E9BR/axZMhA3QTeoHIKU62Rogr7ZmTtWpnYdi69npNM=";
        })
      ]);

    meta.platforms = lib.platforms.darwin;
    meta.mainProgram = "emacs";
  })
