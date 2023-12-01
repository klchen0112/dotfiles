{ inputs
, outputs
, lib
, config
, pkgs
, username
, ...
}: {
  services.emacs = {
    enable = true;
    package = pkgs.emacs-plus;
  };
}
