{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  ...
}: {
  services.emacs = {
    enable = true;
    package = pkgs.emacsPlus29;
  };
  environment.variables.EDITOR = "emacs";
}
