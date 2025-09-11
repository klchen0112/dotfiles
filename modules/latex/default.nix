{
  flake.modules.homeManager.latex =
    { pkgs, ... }:
    {
      programs.texlive = {
        enable = true;
        # packages = pkgs.texliveFull;
        extraPackages = tp: {
          inherit (tp)
            scheme-full
            collection-latexrecommended
            collection-xetex

            aligned-overset
            blindtext
            catchfile
            datetime2
            enumitem
            multirow
            spreadtab
            tracklang
            xstring
            ;
        };
      };
    };
}
