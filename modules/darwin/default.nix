{
  flake-file.inputs = {
    #  MacOS
    nix-darwin = {
      url = "github:LnL7/nix-darwin"; # MacOS Package Management
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
    };
  };
  flake.modules.darwin.darwin =
    { inputs, ... }:
    {
      imports = [
        inputs.mac-app-util.darwinModules.default
        inputs.srvos.darwinModules.desktop
        inputs.srvos.darwinModules.mixins-terminfo
        inputs.srvos.darwinModules.mixins-nix-experimental
        inputs.srvos.darwinModules.mixins-trusted-nix-caches
      ];
    };
  flake.modules.homeManager.desktop =
    { inputs, pkgs, ... }:
    {
      imports = [
        inputs.mac-app-util.homeManagerModules.default
      ];
    };
}
