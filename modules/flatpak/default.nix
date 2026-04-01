{ inputs, ... }:
{
  flake-file.inputs = {
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };
  den.aspects.flatpak.nixos = {
    imports = [
      inputs.nix-flatpak.nixosModules.nix-flatpak
    ];
    services.flatpak.enable = true;
  };
  den.aspects.flatpak.homeManager =
    { pkgs, ... }:
    {
      imports = [
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
      ];
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
