{
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
