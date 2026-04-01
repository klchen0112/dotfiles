{ inputs, ... }:
{
  flake-file.inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        darwin.follows = "nix-darwin";
      };
    };
  };
  den.aspects.access-tokens.homeManager =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [ inputs.agenix.homeManagerModules.default ];
      age.secrets.access-tokens.file = inputs.self + /secrets/access-tokens.age;
      nix.extraOptions = ''
        !include ${config.age.secrets.access-tokens.path}
      '';
      age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      age.secretsDir = "${config.home.homeDirectory}/.local/share/agenix/agenix";
      age.secretsMountPoint = "${config.home.homeDirectory}/.local/share/agenix/agenix.d";
    };

  den.aspects.access-tokens.nixos =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [ inputs.agenix.nixosModules.default ];
      age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      age.secrets.access-tokens.file = inputs.self + /secrets/access-tokens.age;
      nix.extraOptions = ''
        !include ${config.age.secrets.access-tokens.path}
      '';
    };
  den.aspects.darwin.access-tokens =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [ inputs.agenix.darwinModules.default ];
      age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      age.secrets.access-tokens.file = inputs.self + /secrets/access-tokens.age;
      nix.extraOptions = ''
        !include ${config.age.secrets.access-tokens.path}
      '';
    };

}
