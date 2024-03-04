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
    additionalPath = ["/Users/${username}"];
  };
  environment.variables.EDITOR = "emacs";
}
