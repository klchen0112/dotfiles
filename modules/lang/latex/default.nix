{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    texlive.combined.scheme-full
  ];
}
