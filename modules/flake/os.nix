{ inputs, lib, ... }:
let
  mkNixos =
    system: _cls: name:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        inputs.home-manager.nixosModules.home-manager
        inputs.self.modules.nixos.root
        inputs.self.modules.nixos.nix
        inputs.self.modules.nixos.nixos
        inputs.self.modules.nixos.network
        # inputs.self.modules.nixos.${_cls}
        inputs.self.modules.nixos.${name}
        {
          networking.hostName = lib.mkDefault name;
          nixpkgs.hostPlatform = lib.mkDefault system;
          system.stateVersion = "25.05";
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
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
        inputs.self.modules.darwin.nix
        inputs.self.modules.darwin.darwin
        inputs.self.modules.darwin.${name}
        {
          networking.hostName = lib.mkDefault name;
          nixpkgs.hostPlatform = lib.mkDefault system;
          system.stateVersion = 6;

          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
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
