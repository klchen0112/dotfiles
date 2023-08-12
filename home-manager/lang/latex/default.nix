{pkgs, ...}: {
  # programs.texlive = {
  #   enable = true;
  #   extraPackages = tpkgs: { inherit (tpkgs) collection-xetex; };
  #   # packageSet = pkgs.texlive.combine {
  #   #   inherit
  #   #     (pkgs.texlive)
  #   #     scheme-basic
  #   #     dvisvgm
  #   #     dvipng # for preview and export as html
  #   #     wrapfig
  #   #     amsmath
  #   #     ulem
  #   #     hyperref
  #   #     capt-of
  #   #     ;
  #   #   #(setq org-latex-compiler "lualatex")
  #   #   #(setq org-preview-latex-default-process 'dvisvgm)
  #   # };
  # };
  home.packages = with pkgs; [texlive.combined.scheme-full];
}
