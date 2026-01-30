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
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        topLevel.inputs.stylix.darwinModules.stylix
      ];
      homeManagerIntegration.autoImport = false;
      homeManagerIntegration.followSystem = false;
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${
        topLevel.config.flake.meta.users.${config.networking.hostname}.base16Scheme
      }.yaml";

    };
  flake.modules.nixos.stylix =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        topLevel.inputs.stylix.nixosModules.stylix
      ];
      homeManagerIntegration.autoImport = false;
      homeManagerIntegration.followSystem = false;
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${
        topLevel.config.flake.meta.users.${config.networking.hostname}.base16Scheme
      }.yaml";

    };
}
