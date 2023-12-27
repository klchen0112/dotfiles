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
    ./emacs/darwin.nix
  ];
}
