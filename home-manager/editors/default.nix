{ inputs
, outputs
, lib
, config
, pkgs
, username
, ...
}: {
  imports = [
    ./vscode
    ./jetbrains
    ./emacs
    ./helix
  ];
  home.packages = with pkgs; [
    wakatime
    hugo
  ];
}
