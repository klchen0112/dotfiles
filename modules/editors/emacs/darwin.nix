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
    enable = false;
    package = pkgs.emacsPlus31;
    additionalPath = ["/Users/${username}"];
    exec = "emacs";
  };
  environment.variables.EDITOR = "emacs";
}
