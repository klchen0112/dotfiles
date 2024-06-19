{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.emacs = {
    enable = false;
    package = pkgs.emacs29-pgtk;
    defaultEditor = true;
    client.enable = true;
    install = true;
    startWithGraphical = true;
  };
}
