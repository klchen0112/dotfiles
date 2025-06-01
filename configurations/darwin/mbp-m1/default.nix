# Configuration for my M1 Macbook Max as headless server
{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "mbp-m1";

  imports = [
    self.darwinModules.default
  ];
  myUsers = [
    "klchen"
  ];


}
