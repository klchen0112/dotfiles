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
  flake.modules.homeManager.access-tokens =
    {
      pkgs,
      config,
      ...
    }:
    {
      home.packages = [
        inputs.agenix.packages.${pkgs.system}.default
      ];
      imports = [ inputs.agenix.homeManagerModules.default ];
      age.secrets.access-tokens.file = inputs.self + /secrets/access-tokens.age;
      nix.extraOptions = ''
        !include ${config.age.secrets.access-tokens.path}
      '';
      age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      age.secretsDir = "${config.home.homeDirectory}/.local/share/agenix/agenix";
      age.secretsMountPoint = "${config.home.homeDirectory}/.local/share/agenix/agenix.d";
    };

  flake.modules.nixos.access-tokens =
    {
      pkgs,
      config,
      ...
    }:
    {
      environment.systemPackages = [
        inputs.agenix.packages.${pkgs.system}.default
      ];
      imports = [ inputs.agenix.nixosModules.default ];
      age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      age.secrets.access-tokens.file = inputs.self + /secrets/access-tokens.age;
      nix.extraOptions = ''
        !include ${config.age.secrets.access-tokens.path}
      '';
    };
  flake.modules.darwin.access-tokens =
    {
      pkgs,
      config,
      ...
    }:
    {
      environment.systemPackages = [
        inputs.agenix.packages.${pkgs.system}.default
      ];
      imports = [ inputs.agenix.darwinModules.default ];
      age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      age.secrets.access-tokens.file = inputs.self + /secrets/access-tokens.age;
      nix.extraOptions = ''
        !include ${config.age.secrets.access-tokens.path}
      '';
    };

}
