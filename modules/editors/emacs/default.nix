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
    package = pkgs.emacs29-pgtk;
    defaultEditor = true;
    client.enable = true;
    install = true;
    startWithGraphical = true;
  };
}
