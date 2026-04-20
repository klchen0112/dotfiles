{
  den.aspects.zsh.homeManager =
    {
      pkgs,
      ...
    }:
    {
      programs.zsh = {
        enable = pkgs.stdenv.isDarwin;
        autosuggestion.enable = true; # Auto suggest options and highlights syntax, searches in history for options
        syntaxHighlighting.enable = true;
        defaultKeymap = "emacs";
        enableCompletion = true;
      };
    };
}
