{pkgs, ...}: {
  programs.texlive = {
    enable = true;
    package = pkgs.texlive.combined.scheme-full;
  };

}
