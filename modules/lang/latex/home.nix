{pkgs, ...}: {
  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: {inherit (tpkgs) scheme-full biblatex latexmk;};
  };
}
