{ pkgs
, ...
}: {
  home.packages = with pkgs; [

  ]++ lib.optionals pkgs.stdenv.isLinux
  [
    anki
    # calibre
    logseq
    zotero
  ];
}
