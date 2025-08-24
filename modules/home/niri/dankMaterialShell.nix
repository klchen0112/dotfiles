{
  flake,
  ...

}:
{

  imports = [

    flake.inputs.DankMaterialShell.homeModules.dankMaterialShell

  ];
  programs.dankMaterialShell = {
    enablea = true;
    enableKeybinds = true;
    enableSystemd = true;
    enableSpawn = true;
  };

}
