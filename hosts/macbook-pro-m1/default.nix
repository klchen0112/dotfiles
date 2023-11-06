{ inputs
, outputs
, lib
, config
, pkgs
, username
, ...
}: {
  imports = [
    inputs.nix-doom-emacs.hmModule
    ../../modules/browser/home.nix
    ../../modules/downloader/home.nix
    ../../modules/editors/home.nix
    ../../modules/graphics/home.nix
    ../../modules/keyboard/home.nix
    ../../modules/lang/home.nix
    ../../modules/media/home.nix
    ../../modules/network/home.nix
    ../../modules/shells/home.nix
    ../../modules/socialMedia/home.nix
    ../../modules/terminal/home.nix
    ../../modules/vm/home.nix
    ../../modules/im/home.nix
    # ../../modules/windowManager
    # ../../modules/vpn
    ../../modules/notes/home.nix
  ];


  home = {
    username = "${username}";
    homeDirectory = "/Users/${username}";
    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;
  home.activation = {
    trampolineApps =
      let
        apps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = config.home.packages;
          pathsToLink = "/Applications";
        };
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        toDir="$HOME/Applications/HMApps"
        fromDir="${apps}/Applications"
        rm -rf "$toDir"
        mkdir "$toDir"
        (
          cd "$fromDir"
          for app in *.app; do
            /usr/bin/osacompile -o "$toDir/$app" -e "do shell script \"open '$fromDir/$app'\""
            icon="$(/usr/bin/plutil -extract CFBundleIconFile raw "$fromDir/$app/Contents/Info.plist")"
            if [[ $icon != *".icns" ]]; then
              icon="$icon.icns"
            fi
            mkdir -p "$toDir/$app/Contents/Resources"
            cp -f "$fromDir/$app/Contents/Resources/$icon" "$toDir/$app/Contents/Resources/applet.icns"
          done
        )
      '';
  };
}
