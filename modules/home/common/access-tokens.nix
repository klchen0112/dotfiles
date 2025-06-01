{ flake
, config
, pkgs
, ...
}:
{

  imports = [
    flake.inputs.agenix.homeManagerModules.default
  ];
  home.packages = [
    flake.inputs.agenix.packages.${pkgs.system}.default
  ];
  age = {
    secretsDir = "${config.home.homeDirectory}/.config/agenix/agenix";
    secretsMountPoint = "${config.home.homeDirectory}/.config/agenix/agenix.d";
    secrets.access-tokens.file = flake.inputs.self + /secrets/access-tokens.age;
  };
  nix.extraOptions = ''
    !include ${config.age.secrets.access-tokens.path}
  '';
}
