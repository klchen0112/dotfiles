{
  inputs,
  ...
}:
{
  den.aspects.persist = {
    nixos =
      { pkgs, ... }:
      {
        environment.etc = {
          "machine-id".source = "/nix/persist/etc/machine-id";
          "ssh/ssh_host_rsa_key".source = "/nix/persist/etc/ssh/ssh_host_rsa_key";
          "ssh/ssh_host_rsa_key.pub".source = "/nix/persist/etc/ssh/ssh_host_rsa_key.pub";
          "ssh/ssh_host_ed25519_key".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
          "ssh/ssh_host_ed25519_key.pub".source = "/nix/persist/etc/ssh/ssh_host_ed25519_key.pub";
        };

      };
  };
}
