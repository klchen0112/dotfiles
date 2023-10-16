{ pkgs, ... }: {
  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: {
      inherit (tpkgs)
        scheme-small
        dvisvgm dvipng # for preview and export as html
        wrapfig amsmath ulem hyperref capt-of;
    };

  };
}
