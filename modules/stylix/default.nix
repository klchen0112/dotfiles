{ inputs, ... }:
{
  flake-file.inputs = {
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nur.follows = "nur";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  # den.aspects.stylix-home.stylix-home =
  #   {
  #     config,
  #     pkgs,
  #     ...
  #   }:
  #   {
  #     imports = [
  #       inputs.stylix.homeModules.stylix
  #     ];

  #     # enable gtk
  #     stylix.targets.gtk.enable = true;
  #   };
  den.aspects.stylix.darwin =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        inputs.stylix.darwinModules.stylix
      ];
      stylix.homeManagerIntegration.autoImport = false;
      stylix.homeManagerIntegration.followSystem = false;
    };
  den.aspects.stylix.nixos =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];
      stylix.homeManagerIntegration.autoImport = false;
      stylix.homeManagerIntegration.followSystem = false;
    };
}
