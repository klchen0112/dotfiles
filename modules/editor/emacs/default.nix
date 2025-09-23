{ inputs, ... }:
{
  flake-file.inputs = rec {
    emacs-overlay = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/emacs-overlay/master";
    };
    doomemacs = {
      url = "github:doomemacs/doomemacs";
      flake = false;
    };
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.doomemacs.follows = "doomemacs";
    };
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

          emacs-lsp-booster
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

          if test "''${doom_rev:-}" = "${inputs.doomemacs.rev}"; then
            echo "DOOM Emacs already at revision ${inputs.doomemacs.rev}"
            exit 0 # doom already pointing to same revision
          fi

          (
            echo "DOOM Emacs obtaining revision ${inputs.doomemacs.rev}"
            if ! test -d "$HOME/.config/emacs/.git"; then
              git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
            fi
            cd "$HOME/.config/emacs"
            git fetch --depth 1 origin "${inputs.doomemacs.rev}"
            git reset --hard "${inputs.doomemacs.rev}"
            bin/doom install --no-config --no-env --no-install --no-fonts --no-hooks --force
            echo "DOOM Emacs updated to revision ${inputs.doomemacs.rev}"
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
