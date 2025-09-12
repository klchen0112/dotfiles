{
  flake-file.inputs = {
    agenix.url = "github:ryantm/agenix";
  };
  flake.modules.nixos.access-tokens =
    {
      pkgs,
      config,
      inputs,
      ...
    }:
    {
      environment.systemPackages = [
        inputs.agenix.packages.${pkgs.system}.default
      ];
      imports = [ inputs.agenix.nixosModules.default ];
      age.secrets.access-tokens.file = inputs.self + /secrets/access-tokens.age;
      nix.extraOptions = ''
        !in clude ${config.age.secrets.access-tokens.path}
      '';
    };
  flake.modules.darwin.access-tokens =
    {
      pkgs,
      config,
      inputs,
      ...
    }:
    {
      environment.systemPackages = [
        inputs.agenix.packages.${pkgs.system}.default
      ];
      imports = [ inputs.agenix.darwinModules.default ];
      age.secrets.access-tokens.file = inputs.self + /secrets/access-tokens.age;
      nix.extraOptions = ''
        !include ${config.age.secrets.access-tokens.path}
      '';
    };

}
