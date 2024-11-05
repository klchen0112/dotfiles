# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{
  inputs,
  pkgs,
}: rec {
  # example = pkgs.callPackage ./example { };
  TsangerJinKai02 = inputs.own-nur.packages.${pkgs.system}.TsangerJinKai02;
  Jigmo = inputs.own-nur.packages.${pkgs.system}.Jigmo;
  # this code from https://github.com/dezzw/demacs/blob/main/flake.nix
  mps-darwin = pkgs.mps.overrideAttrs (
    old: {
      buildInputs =
        old.buildInputs
        ++ [pkgs.apple-sdk];
      # Define the build phase using the absolute path to xcodebuild and set DerivedData path
      buildPhase = ''
        echo "Building MPS on macOS using xcodebuild..."

        # Set the MACOSX_DEPLOYMENT_TARGET to match the xcodebuild target
        export MACOSX_DEPLOYMENT_TARGET=15.1

        cd code

        # Define a writable DerivedData path within the build environment
        DERIVED_DATA="$TMPDIR/DerivedData"

        # Create the DerivedData directory
        mkdir -p "$DERIVED_DATA"

        # Run xcodebuild with the specified DerivedData path
        xcodebuild -scheme mps \
                             -configuration Release \
                             -project mps.xcodeproj \
                             -derivedDataPath "$DERIVED_DATA" \
                             OTHER_CFLAGS="-Wno-error=unused-but-set-variable -Wno-unused-but-set-variable -mmacos-version-min=15.1"
      '';
      # Define the install phase: copy the built library and headers to the output directory
      installPhase = ''
        echo "Installing MPS to $out..."

        mkdir -p $out/lib
        cp "$TMPDIR/source/code/xc/Release/libmps.a" $out/lib/

        mkdir -p $out/include
        cp mps*.h $out/include/
      '';
      meta.platforms = (old.meta.platforms or []) ++ ["aarch64-darwin"];
    }
  );
  # this code from https://github.com/dezzw/demacs/blob/main/flake.nix
  emacsIgc = (inputs.emacs-overlay.packages.${pkgs.system}.emacs-git.override {withImageMagick = true;}).overrideAttrs (old: {
    name = "emacs-30";
    version = "igc";
    src = pkgs.fetchFromGitHub {
      owner = "emacs-mirror";
      repo = "emacs";
      rev = "a19e818265e80d3dd2043a6a4ef2c4e8a8014f77";
      hash = "sha256-s73Km3rBhafd8cJXbJi+AWopdXqQPLMANy7wlR0XkqY=";
    };
    configureFlags =
      (old.configureFlags or [])
      ++ [
        # "--with-xwidgets" # withXwidgets failed with mps enabled
        "--with-mps"
        "--with-native-compilation=aot"
      ];
    buildInputs =
      old.buildInputs
      ++ [pkgs.xcodebuild mps-darwin];
    patches =
      (old.patches or [])
      ++ [
        # Fix OS window role so that yabai can pick up Emacs
        (pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
          sha256 = "+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
        })

        # Add setting to enable rounded window with no decoration (still have to alter default-frame-alist)
        (pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/round-undecorated-frame.patch";
          sha256 = "uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
        })

        # Make Emacs aware of OS-level light/dark mode
        (pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-30/system-appearance.patch";
          sha256 = "3QLq91AQ6E921/W9nfDjdOUWR8YVsqBAT/W9c1woqAw=";
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
  emacsPlus31 = inputs.emacs-overlay.packages.${pkgs.system}.emacs-git.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
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
        # (pkgs.fetchpatch {
        #   url = "https://raw.githubusercontent.com/sincebyte/neo-emacs/master/patches/emacs31/ns-alpha-background.patch";
        #   sha256 = "sha256-3OG1tMpg/1jrP/gsnFCkqJ22OkS/d8voOUqiOk7iUkE=";
        # })
      ];
    meta.platforms = pkgs.lib.platforms.darwin;
    meta.mainProgram = "emacs";
  });
}
