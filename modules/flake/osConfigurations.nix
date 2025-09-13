{ inputs, ... }:
let
  inherit (inputs.self.lib.mk-os)
    darwin linux
    ;
in
{
  flake.darwinConfigurations = {
    mbp-m1 = darwin "mbp-m1";
  };
  flake.nixosConfigurations = {
    a99r50 = linux "a99r50";
  };
}
