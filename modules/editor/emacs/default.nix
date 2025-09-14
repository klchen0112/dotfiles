{ inputs, ... }:
{
  flake-file.inputs = {
    emacs-overlay.url = "github:nix-community/emacs-overlay/master";
    doom-config = {
      url = "github:klchen0112/doom";
      # url = "git+file:///Users/klchen/my/doom";
      flake = false;
    };
    doom-emacs.flake = false;
    doom-emacs.url = "github:doomemacs/doomemacs";

  };
  flake.modules.homeManager.emacs =
    {
      lib,
      pkgs,
      ...
    }:
    let

      emacsPackage =
        (if pkgs.stdenv.isDarwin then pkgs.local.emacsIGC else pkgs.emacs-igc-pgtk).pkgs.withPackages
          (
            epkgs: with epkgs; [
              treesit-grammars.with-all-grammars
              rime
              telega
            ]
          );
      # doomPath = "${config.home.homeDirectory}/my/dotfiles/modules/editors/emacs/doom";
      extraPackages =
        with pkgs;
        [
          fd
          curl
          # org mode dot
          graphviz
          imagemagick
          # mpvi required
          tesseract5
          ffmpeg
          poppler
          ffmpegthumbnailer
          mediainfo
          sqlite
          # email
          # mu4e
          # spell check
          hunspell
          languagetool
          # for emacs lsp booster
          emacs-lsp-booster
          pkg-config
          # telega

          #
          # texliveFull

          # emacs-lsp-booster
          # ------------------- Python ---

          # poetry
          # ------------------- Web -------------------------
          mermaid-cli
        ]
        ++ (lib.optionals pkgs.stdenv.isDarwin) [
          # pngpaste for org mode download clip
          pngpaste
          hugo
          # pkgs.local.org-reminders
        ];
      doom-install = pkgs.writeShellApplication {
        name = "doom-install";
        runtimeInputs = with pkgs; [
          git
          emacsPackage
          ripgrep
          openssh
        ];
        text = ''
          set -e
          if test -f "$HOME"/.config/emacs/.local/etc/@/init*.el; then
            doom_rev="$(rg "put 'doom-version 'ref '\"(\w+)\"" "$HOME"/.config/emacs/.local/etc/@/init*.el -or '$1')"
          fi

          if test "''${doom_rev:-}" = "${inputs.doom-emacs.rev}"; then
            echo "DOOM Emacs already at revision ${inputs.doom-emacs.rev}"
            exit 0 # doom already pointing to same revision
          fi

          (
            echo "DOOM config obtaining revision ${inputs.doom-config.rev}"
            if ! test -d "$HOME/.config/doom/.git"; then
              git clone --depth 1 https://github.com/klchen0112/doom "$HOME/.config/doom"
            fi
            cd "$HOME/.config/doom"
            git fetch --depth 1 origin "${inputs.doom-config.rev}"
            git reset --hard "${inputs.doom-config.rev}"
            ${emacsPackage}/bin/emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "config.org")'
          )

          (
            echo "DOOM Emacs obtaining revision ${inputs.doom-emacs.rev}"
            if ! test -d "$HOME/.config/emacs/.git"; then
              git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
            fi
            cd "$HOME/.config/emacs"
            git fetch --depth 1 origin "${inputs.doom-emacs.rev}"
            git reset --hard "${inputs.doom-emacs.rev}"
            bin/doom install --no-config --no-env --no-install --no-fonts --no-hooks --force
            echo "DOOM Emacs updated to revision ${inputs.doom-emacs.rev}"
            bin/doom sync -e --force
          )
        '';
      };
    in
    {
      home.packages = extraPackages;

      programs.emacs = {
        enable = true;
        package = emacsPackage;
      };
      services.emacs = {
        enable = true;
        package = emacsPackage;
        client.enable = true;
        socketActivation.enable = true;
        startWithUserSession = "graphical";
        defaultEditor = true;
      };
      home.activation.doom-install = ''run ${lib.getExe doom-install}'';
    };
}
