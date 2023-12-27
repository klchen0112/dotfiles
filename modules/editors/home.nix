{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  ...
}: {
  imports = [
    ./vscode/home.nix
    ./jetbrains/home.nix
    ./emacs/home.nix
    ./vim/home.nix
  ];
  home.packages = with pkgs; [
    wakatime
    hugo
  ];
}
