{
  den.aspects.k8s.k8s =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        kubectl
      ];
    };
}
