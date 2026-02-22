{

  flake.modules.nixos.k3s-master =
    { pkgs, ... }:
    {

      services.k3s = {
        role = "server";
        clusterInit = true;
        extraFlags = toString [
          # "--debug" # Optionally add additional args to k3s
        ];
      };
    };
}
