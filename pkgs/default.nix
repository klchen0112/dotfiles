# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  inputs,
  pkgs,
}: {
  # example = pkgs.callPackage ./example { };
  TsangerJinKai02 = inputs.own-nur.packages.${pkgs.system}.TsangerJinKai02;
  Jigmo = inputs.own-nur.packages.${pkgs.system}.Jigmo;

  emacsPlus31 = inputs.emacs-overlay.packages.${pkgs.system}.emacs-git.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        # Fix OS window role (needed for window managers like yabai)
        (pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
          sha256 = "+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
        })
        # Use poll instead of select to get file descriptors
        (pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/poll.patch";
          sha256 = "bQW9LPmJhMAtP2rftndTdjw0uipPyOp5oXqtIcs7i/Q=";
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
          url = "https://raw.githubusercontent.com/sincebyte/neo-emacs/master/patches/emacs31/ns-alpha-background.patch";
          sha256 = "sha256-3OG1tMpg/1jrP/gsnFCkqJ22OkS/d8voOUqiOk7iUkE=";
        })
      ];
    meta.platforms = pkgs.lib.platforms.darwin;
    meta.mainProgram = "emacs";
  });
}
