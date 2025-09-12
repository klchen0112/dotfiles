{ inputs, ... }:
let
  flake-file.inputs = {
    #  MacOS
     nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    mac-app-util = {
      url = "github:hraban/mac-app-util";
    };
  };
  flake.modules.darwin.darwin = {
    imports = [
      inputs.mac-app-util.darwinModules.default
      # inputs.srvos.darwinModules.desktop
      # inputs.srvos.darwinModules.mixins-terminfo
      # inputs.srvos.darwinModules.mixins-nix-experimental
      # inputs.srvos.darwinModules.mixins-trusted-nix-caches
    ];
  };
  flake.modules.homeManager.desktop =
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
