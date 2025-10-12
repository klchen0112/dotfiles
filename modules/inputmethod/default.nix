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
      rime-install = pkgs.writeShellApplication {
        name = "rime-install";
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
            echo "Rime obtaining revision ${inputs.rime.rev}"
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
          (fcitx5-rime.override { rimeDataPkgs = [ pkgs.local.rime-combo-snow-pinyin ]; })
          fcitx5-configtool
          fcitx5-gtk # gtk im module
        ];
      };

      home.activation.rime-install =
        if pkgs.stdenv.isDarwin then ''run ${lib.getExe rime-install}'' else '''';

    };
}
