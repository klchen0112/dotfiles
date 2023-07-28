{ emacs-overlay
, nixpkgs
, ...
}:
# below code from https://github.com/bbigras/nix-config/blob/master/nix/overlay.nix

let
  inherit (nixpkgs) lib;
  localOverlays =
    lib.mapAttrs'
      (f: _: lib.nameValuePair
        (lib.removeSuffix ".nix" f)
        (import (./overlays + "/${f}")))
      (builtins.readDir ./overlays);
in
localOverlays // {
  default = lib.composeManyExtensions
    ((lib.attrValues localOverlays) ++ [
      emacs-overlay.overlay
    ]);
}
