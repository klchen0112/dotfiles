#
# Doom Emacs: Personally not a fan of github:nix-community/nix-doom-emacs due to performance issues
# This is an ideal way to install on a vanilla NixOS installion.
# You will need to import this from somewhere in the flake (Obviously not in a home-manager nix file)
#
# flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix
#   └─ ./modules
#       └─ ./editors
#           └─ ./vscode
{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      #themes
      mechatroner.rainbow-csv
      gruntfuggly.todo-tree
      johnpapa.vscode-peacock
      # akamud.vscode-theme-onelight
      emmanuelbeziat.vscode-great-icons
      # editor
      streetsidesoftware.code-spell-checker
      christian-kohler.path-intellisense
      # ssh
      ms-vscode-remote.remote-ssh

      vscodevim.vim
      # git
      eamodio.gitlens
      donjayamanne.githistory
      # markdown
      yzhang.markdown-all-in-one

      # python
      ms-python.python

      # nix
      bbenoist.nix
      kamadorueda.alejandra
      jnoortheen.nix-ide
    ];
    enableUpdateCheck = false;
    userSettings = import ./settings.nix;
  };
}
