#
# fish configuration
#
{ pkgs, ... }: {
  home.packages = with pkgs; [
    # anki
    zotero
    # tidgi
    logseq
    # marginnote
  ];
}
