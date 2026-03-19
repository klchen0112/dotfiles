{ inputs, ... }:
{
  flake.modules.homeManager.inputmethod =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      home.activation.installRime = lib.hm.dag.entryAfter [ "writeBoundary" ] (
        if pkgs.stdenv.isDarwin then
          ''
            $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/Library/Rime"

            # Sync schema/dict files from Nix store, overwriting stale files.
            # Exclude user-generated data that must never be overwritten.
            $DRY_RUN_CMD ${pkgs.rsync}/bin/rsync -av \
              --chmod=D0755,F0644 \
              --exclude='*.userdb/' \
              --exclude='user.yaml' \
              --exclude='installation.yaml' \
              --exclude='sync/' \
              "${pkgs.local.rime-combo-snow-pinyin}/share/rime-data/" \
              "${config.home.homeDirectory}/Library/Rime/"

            $VERBOSE_ECHO "KeyTao Rime schema files installed to Library/Rime"
          ''
        else
          ""
      );
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

    };
}
