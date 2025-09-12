{
  flake.modules.homeManager.zsh =
    {
      ...
    }:
    {
      programs.zsh = {
        enable = true;
        autosuggestion.enable = true; # Auto suggest options and highlights syntax, searches in history for options
        syntaxHighlighting.enable = true;
        defaultKeymap = "emacs";
        enableCompletion = true;
      };
    };
}
