{pkgs, ...}: {
  home.packages = with pkgs; [
    kubectl
    minikube
  ];
}
