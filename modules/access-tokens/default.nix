{ inputs, ... }:
{
  flake-file.inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
  den.aspects.sops-home.sops-home =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = with inputs; [
        sops-nix.homeManagerModules.sops
      ];

    };

  den.aspects.sops.nixos =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = with inputs; [
        sops-nix.nixosModules.sops
      ];
    };
  den.aspects.sops.darwin =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = with inputs; [
        sops-nix.darwinModules.sops
      ];
    };

}
