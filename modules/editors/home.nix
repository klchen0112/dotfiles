{ inputs
, outputs
, lib
, config
, pkgs
, username
, ...
}: {
  imports = [
    ./vscode/home.nix
    ./jetbrains/home.nix
    ./emacs/home.nix
    ./helix/home.nix
  ];
  home.packages = with pkgs; [
    wakatime
    hugo
  ];
}
