{ inputs, ... }:
{
  flake-file.inputs = {
    rime = {
      url = "github:klchen0112/rime-snow-combo-pinyin";
      flake = false;
    };
  };
  flake.modules.homeManager.inputmethod =
    {
      pkgs,
      lib,
      ...
    }:
    let
      my-rime-data = pkgs.stdenv.mkDerivation {
        name = "my-rime-config-data";
        src = inputs.rime; # 'self' 指向 flake 自身
        buildInputs = [ pkgs.librime ];
        installPhase = ''
          mkdir -p $out
          cp -r ./* $out/
        '';
      };
      rime-install = pkgs.writeShellApplication {
        name = "doom-install";
        runtimeInputs = with pkgs; [
          git
          openssh
        ];
        text = ''
          if test "''${rime_rev:-}" = "${inputs.rime.rev}"; then
            echo "Rime already at revision ${inputs.rime.rev}"
            exit 0
          fi

          (
            echo "DOOM Emacs obtaining revision ${inputs.doom-emacs.rev}"
            if ! test -d "$HOME/Library/Rime/.git"; then
              git clone --depth 1 https://github.com/klchen0112/rime-snow-combo-pinyin "$HOME/Library/Rime"
            fi
            cd "$HOME/Library/Rime"
            git fetch --depth 1 origin "${inputs.rime.rev}"
            git reset --hard "${inputs.rime.rev}"
          )
        '';
      };
    in
    {
      i18n.inputMethod = {
        enable = pkgs.stdenv.isLinux;
        type = "fcitx5";
        fcitx5.addons = with pkgs; [
          fcitx5-rime.override
          { rimeDataPkgs = [ my-rime-data ]; }
          fcitx5-configtool
          fcitx5-gtk # gtk im module
        ];
      };

      home.activation.rime-install = lib.optionalAttrs pkgs.stdenv.isDarwin ''run ${lib.getExe rime-install}'';

    };
}
