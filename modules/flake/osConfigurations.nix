{ inputs, ... }:
let
  inherit (inputs.self.lib.mk-os)
    darwin linux wsl
    ;
in
{
  flake.darwinConfigurations = {
    mbp-m1 = darwin "mbp-m1";
  };
}
