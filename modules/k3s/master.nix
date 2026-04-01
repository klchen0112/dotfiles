{

  den.aspects.k3s-master.nixos =
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
