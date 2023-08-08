#
# fish configuration
#
{ pkgs, ... }: {
  home.packages = with pkgs; [
    # anki
    tidgi
    logseq
    marginnote
  ];
}
