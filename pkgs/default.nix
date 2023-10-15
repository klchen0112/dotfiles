# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ inputs, pkgs }: {
  # example = pkgs.callPackage ./example { };
  sf-pro = inputs.apple-fonts.packages.${pkgs.system}.sf-pro;
  sf-pro-nerd = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;

  sf-compact = inputs.apple-fonts.packages.${pkgs.system}.sf-compact;
  sf-compact-nerd = inputs.apple-fonts.packages.${pkgs.system}.sf-compact-nerd;

  sf-mono = inputs.apple-fonts.packages.${pkgs.system}.sf-mono;
  sf-mono-nerd = inputs.apple-fonts.packages.${pkgs.system}.sf-mono-nerd;

  sf-arabic = inputs.apple-fonts.packages.${pkgs.system}.sf-arabic;
  sf-arabic-nerd = inputs.apple-fonts.packages.${pkgs.system}.sf-arabic-nerd;

  ny = inputs.apple-fonts.packages.${pkgs.system}.ny;
  ny-nerd = inputs.apple-fonts.packages.${pkgs.system}.ny-nerd;


  emacs-plus = inputs.emacs-overlay.packages.${pkgs.system}.emacs-unstable.overrideAttrs (old: {
    patches =
      (old.patches or [ ])
      ++ [
        # Fix OS window role (needed for window managers like yabai)
        (pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
          sha256 = "+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
        })
        # Use poll instead of select to get file descriptors
        (pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/poll.patch";
          sha256 = "jN9MlD8/ZrnLuP2/HUXXEVVd6A+aRZNYFdZF8ReJGfY=";
        })
        # Enable rounded window with no decoration
        (pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/round-undecorated-frame.patch";
          sha256 = "uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
        })
        # Make Emacs aware of OS-level light/dark mode
        (pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/system-appearance.patch";
          sha256 = "sha256-oM6fXdXCWVcBnNrzXmF0ZMdp8j0pzkLE66WteeCutv8=";
        })
      ];
  });
}
