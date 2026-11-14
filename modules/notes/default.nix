{
  lib,
  den,
  ...
}:
{
  # Obsidian 只在 mbp-m1 / a99r50 上由 klchen 使用（见 modules/users/klchen.nix）
  den.aspects.obsidian.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.obsidian ];
    };

  den.aspects.note =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
          anki
          # calibre
          # logseq
          zotero
        ];
    };
}
