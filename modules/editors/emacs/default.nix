{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {

  services.emacs = {
    enable = false;
    package = pkgs.emacs-pgtk;
    defaultEditor = true;
    # client.enable = true;
  };

}
