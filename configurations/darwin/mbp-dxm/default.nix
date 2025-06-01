{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "mbp-dxm";

  imports = [
    self.darwinModules.default
  ];
  myusers = [
    "chenkailong_dxm"
  ];
  home-manager.backupFileExtension = "nixos-unified-template-backup";

  system.stateVersion = "25.11";

}
