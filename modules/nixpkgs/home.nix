{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  ...
}:
{
  imports = [
    # ./nix.nix
  ];
  nix.gc = {
    automatic = true;
    frequency = "weekly";
  };
  nix.settings = {
    trusted-users = [
      "root"
      "${username}"
      "@wheel"
    ];
    extra-experimental-features = "nix-command flakes";
    accept-flake-config = true;
  };
  nix.extraOptions = ''
    !include ${config.age.secrets.access-tokens.path}
  '';
}
