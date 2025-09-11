{
  flake.modules.homeManager.stylix =
    {
      pkgs,
      config,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.stylix.homeModules.stylix
        ./base.nix
      ];
      # enable gtk
      stylix.targets.gtk.enable = true;
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.me.base16Scheme}.yaml";
    };
  flake.modules.darwin.stylix =
    {
      pkgs,
      config,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.stylix.darwinModules.stylix
        ./base.nix
      ];
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.machine.base16Scheme}.yaml";
      homeManagerIntegration.autoImport = false;
      homeManagerIntegration.followSystem = false;
    };
  flake.modules.nixos.stylix =
    {
      pkgs,
      config,
      inputs,
      ...
    }:
    {
      imports = [
        inputs.stylix.nixosModules.stylix
        ./base.nix
      ];
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.machine.base16Scheme}.yaml";
      homeManagerIntegration.autoImport = false;
      homeManagerIntegration.followSystem = false;
    };

}
