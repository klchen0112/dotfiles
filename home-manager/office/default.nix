#
# fish configuration
#
{ pkgs, ... }: {
  home.packages = with pkgs; [
    # calibre
    # plexamp

  ] ++ lib.optionals pkgs.stdenv.isDarwin
    [ raycast ];

}
