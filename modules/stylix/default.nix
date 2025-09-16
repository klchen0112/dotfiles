topLevel: {
  flake-file.inputs = {
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nur.follows = "nur";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  flake.modules.homeManager.stylix =
    {
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        topLevel.inputs.stylix.homeModules.stylix
      ];
      # enable gtk
      stylix.targets.gtk.enable = true;
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${
        topLevel.config.flake.meta.users.${config.home.username}.base16Scheme
      }.yaml";
    };
  flake.modules.darwin.stylix =
    {
      ...
    }:
    {
      imports = [
        topLevel.inputs.stylix.darwinModules.stylix
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
        topLevel.inputs.stylix.nixosModules.stylix
      ];
      homeManagerIntegration.autoImport = false;
      homeManagerIntegration.followSystem = false;
    };
}
