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
    package = pkgs.emacsPlus30;
    additionalPath = ["/Users/${username}"];
  };
  environment.variables.EDITOR = "emacs";
}
