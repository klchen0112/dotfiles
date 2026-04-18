{ inputs, ... }:
{
  flake-file.inputs = {
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };
  den.aspects.flatpak.homeManager =
    { pkgs, ... }:
    {
      imports = [
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
      ];
      xdg.portal.enable = true;
      home.packages = with pkgs; [ flatpak ];
      services.flatpak.enable = true;
      services.flatpak.update = {
        auto = {
          enable = true;
        };
        onActivation = true;
      };
    };

}
