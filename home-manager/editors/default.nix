{ inputs
, outputs
, lib
, config
, pkgs
, username,... }: {
  imports = [
    ./vscode
    ./jetbrains
    ./emacs
  ];
  home.packages = with pkgs; [
    wakatime
    hugo
  ];
}
