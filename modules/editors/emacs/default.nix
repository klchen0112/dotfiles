{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  services.emacs = {
    enable = true;
    package =
      if pkgs.stdenv.hostPlatform.isDarwin then
        pkgs.emacs-plus
      else
        pkgs.emacs29;
  };
}
