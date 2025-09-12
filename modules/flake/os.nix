{ inputs, lib, ... }:
let
  mkNixos =
    system: cls: name:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        inputs.self.modules.nixos.${cls}
        inputs.self.modules.nixos.${name}
        {
          networking.hostName = lib.mkDefault name;
          nixpkgs.hostPlatform = lib.mkDefault system;
          system.stateVersion = "25.05";
        }
      ];
    };
  linux = mkNixos "x86_64-linux" "nixos";
  linux-arm = mkNixos "aarch_64-linux" "nixos";

  wsl = mkNixos "x86_64-linux" "wsl";
  mkDarwin =
    system: name:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        inputs.home-manager.darwinModules.home-manager
        inputs.self.modules.darwin.darwin
        inputs.self.modules.darwin.${name}
        {
          networking.hostName = lib.mkDefault name;
          nixpkgs.hostPlatform = lib.mkDefault system;
          system.stateVersion = 6;
        }
      ];
    };
  darwin = mkDarwin "aarch64-darwin";
in
{
  flake.lib.mk-os = {
    inherit darwin;
    inherit wsl linux linux-arm;
  };
}
