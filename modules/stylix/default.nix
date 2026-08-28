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
  den.aspects.stylix-home.stylix-home =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        inputs.stylix.homeModules.stylix
      ];
      # 不自动开启所有 targets；各程序的主题开启写在对应 aspect 的 programs.<name> 旁
      stylix.autoEnable = false;
    };
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
      stylix.autoEnable = true;
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
      stylix.autoEnable = true;
      stylix.homeManagerIntegration.autoImport = false;
      stylix.homeManagerIntegration.followSystem = false;
    };
}
