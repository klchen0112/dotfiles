{ inputs, ... }:
{
  flake-file.inputs = {
stylix = {
      url = "github:nix-community/stylix";
};
  };
  flake.modules.homeManager.stylix =
    {
      ...
    }:
    {
      imports = [
        inputs.stylix.homeModules.stylix
      ];
      # enable gtk
      stylix.targets.gtk.enable = true;

    };
  flake.modules.darwin.stylix =
    {
      ...
    }:
    {
      imports = [
        inputs.stylix.darwinModules.stylix
      ];
      homeManagerIntegration.autoImport = false;
      homeManagerIntegration.followSystem = false;
    };
  flake.modules.nixos.stylix =
    {
      ...
    }:
    {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];
      homeManagerIntegration.autoImport = false;
      homeManagerIntegration.followSystem = false;
    };
}
