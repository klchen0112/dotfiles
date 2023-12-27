{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.emacs = {
    enable = true;
    package = pkgs.emacs-unstable-pgtk;
    defaultEditor = true;
    client.enable = true;
    install = true;
    startWithGraphical = true;
  };
}
