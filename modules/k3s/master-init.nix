{

  den.aspects.k3s-master-init.nixos =
    { pkgs, ... }:
    {
      services.k3s = {
        clusterInit = true;
      };
    };
}
