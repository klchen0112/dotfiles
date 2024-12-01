{
  inputs,
  outputs,
  config,
  pkgs,
  username,
  system,
  ...
}: {
  services.aerospace = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./aerospace.toml);
  };
}
