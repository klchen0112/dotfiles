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
    package = pkgs.emacsPlus31;
    additionalPath = ["/Users/${username}"];
    exec = "emacs --bg-daemon";
  };
  environment.variables.EDITOR = "emacs";
}
