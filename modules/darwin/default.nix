{ inputs, ... }:
let
  flake-file.inputs = {
    #  MacOS
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
    mac-app-util.inputs.nixpkgs.follows = "nixpkgs";
    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.darwin.darwin = {
    imports = [
      inputs.mac-app-util.darwinModules.default
      inputs.srvos.darwinModules.desktop
      inputs.srvos.darwinModules.mixins-terminfo
      inputs.srvos.darwinModules.mixins-nix-experimental
      inputs.srvos.darwinModules.mixins-trusted-nix-caches
      inputs.self.modules.darwin.font
      inputs.self.modules.darwin.system
    ];
  };
  flake.modules.homeManager.home =
    { ... }:
    {
      imports = [
        inputs.mac-app-util.homeManagerModules.default
      ];
    };

in
{
  inherit flake flake-file;
}
