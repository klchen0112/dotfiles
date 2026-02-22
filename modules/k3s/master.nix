{

  flake.modules.nixos.k3s-master =
    { pkgs, ... }:
    {

      services.k3s = {
        role = "server";
        extraFlags = toString [
          # "--debug" # Optionally add additional args to k3s
        ];
      };
    };
}
