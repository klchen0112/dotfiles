{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  services.emacs = {
    enable = true;
    package =pkgs.emacs-plus;
  };
}
