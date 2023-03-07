{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true; # Auto suggest options and highlights syntax, searches in history for options
    enableSyntaxHighlighting = true;
    defaultKeymap = "emacs";
    enableCompletion = true;
    history.size = 100000;
  };
}
