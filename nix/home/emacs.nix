{ pkgs, lib, inputs, system, ... }:

{
  # on macOS, emacs can be launched via:
  #
  # open -a ~/Applications/Home\ Manager\ Apps/Emacs.app
  programs.emacs = {
    enable = true;
    package = inputs.emacs-overlay.packages.${system}.emacsGit;
  };

}
