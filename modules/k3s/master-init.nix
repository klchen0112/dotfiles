{

  flake.modules.nixos.k3s-master-init =
    { pkgs, ... }:
    {
      services.k3s = {
        clusterInit = true;
      };
    };
}
