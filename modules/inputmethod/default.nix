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
      config,
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
          (fcitx5-rime.override {
            rimeDataPkgs = [
              pkgs.local.rime-combo-snow-pinyin
              pkgs.rime-data
            ];
          })
          qt6Packages.fcitx5-configtool
          fcitx5-gtk # gtk im module
        ];
        fcitx5.waylandFrontend = true;
        fcitx5.settings.inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "rime";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "rime";
        };
      };
      services.syncthing.settings.folders."rime-sync" = {
        id = "w4pgi-mnhem";
        path =
          if pkgs.stdenv.isDarwin then
            "~/Library/Mobile Documents/iCloud~dev~fuxiao~app~hamsterapp/Documents/sync"
          else
            "${config.home.homeDirectory}/.local/share/fcitx5/rime/sync";
        devices = [
          "redmi-12t-pro"
          "tower"
          "mbp-m1"
          "a99r50"
        ];
      };

      home.activation.rime-install =
        if pkgs.stdenv.isDarwin then ''run ${lib.getExe rime-install}'' else '''';

    };
}
