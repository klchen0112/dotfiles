{

  den.aspects.k3s-node.nixos =
    { pkgs, ... }:
    {
      services.k3s = {
        role = "agent";
        extraFlags = toString [
          "--debug" # Optionally add additional args to k3s
        ];
        serverAddr = "https://192.168.0.198:6443";
      };
    };
}
