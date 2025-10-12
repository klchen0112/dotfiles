{
  flake-file.inputs = {
    DankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  flake.modules.homeManager.dankMaterialShell =
    {
      inputs,
      config,
      ...

    }:
    {

      imports = [
        inputs.DankMaterialShell.homeModules.dankMaterialShell
      ];
      programs.dankMaterialShell = {
        enable = true;
        enableKeybinds = true;
        enableSystemd = true;
        enableSpawn = false;
      };
    };
}
