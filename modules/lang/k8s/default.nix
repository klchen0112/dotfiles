{
  den.aspects.k8s.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        kubectl
        kubernetes-helm
      ];
    };
}
