{ inputs, lib, ... }:
let
  mkNixos =
    _cls: name:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        inputs.home-manager.nixosModules.home-manager
        inputs.self.modules.nixos.root
        inputs.self.modules.nixos.ssh
        inputs.self.modules.nixos.nix
        inputs.self.modules.nixos.${_cls}
        inputs.self.modules.nixos.${name}
        {
          system.stateVersion = "25.11";
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
        }
      ];
    };
  linux = mkNixos "nixos";
  linux-arm = mkNixos "nixos";

  wsl = mkNixos "wsl";
  darwin =
    name:
    inputs.nix-darwin.lib.darwinSystem {
      modules = [
        inputs.home-manager.darwinModules.home-manager
        inputs.self.modules.darwin.nix
        inputs.self.modules.darwin.darwin
        inputs.self.modules.darwin.${name}
        {
          system.stateVersion = 6;
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
        }
      ];
    };
  mkNode =
    name: cfg:
    let
      inherit (cfg.pkgs.stdenv.hostPlatform) system;
      deployLib = inputs.deploy-rs.lib.${system};
    in
    {
      hostname = "${name}.klchen.duckdns.org";
      profiles.system = {
        user = "root";
        path = deployLib.activate.nixos cfg;
      };
    };

in
{
  flake.lib.mk-os = {
    inherit darwin;
    inherit wsl linux linux-arm;
    inherit mkNode;
  };
}
