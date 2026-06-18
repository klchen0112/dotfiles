{ inputs, ... }:
{
  flake-file.inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
  den.aspects.sops-home.homeManager =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = with inputs; [
        sops-nix.homeManagerModules.sops
      ];

      sops = {
        age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
        age.generateKey = false;
      };
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
      sops = {
        age.sshKeyPaths = [
          "/etc/ssh/ssh_host_ed25519_key"
        ];
        age.generateKey = false;
      };
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
      sops = {
        age.sshKeyPaths = [
          "/etc/ssh/ssh_host_ed25519_key"
        ];
        age.generateKey = false;
      };
    };

}
